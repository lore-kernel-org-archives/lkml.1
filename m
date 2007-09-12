Return-Path: <linux-kernel-owner+w=401wt.eu-S1761924AbXILFjb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761924AbXILFjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 01:39:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbXILFjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 01:39:23 -0400
Received: from web52004.mail.re2.yahoo.com ([206.190.49.251]:22486 "HELO
	web52004.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755498AbXILFjW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 01:39:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=CT20oDzIHlAl6de6hFF0h25UzH9ORr/W28ScEuzd+nkdOWLWrZ0b55LJETw9cm7EEBA5atDDQJZpBRn8s/tspv2oJPd9kimhefJazLgDQSYyQAyuoYw+txJ9peaotJuIWK8nN3qjC+oNJG+Vlv9PdlIq2hXmZfSPDiWgylWQ9Q0=;
X-YMail-OSG: NYWgfQoVM1lOEyBgCxlWBJs0F97tDdNtr2sAr2wAxtpqV6ho7b7WPc_TE3GFMXaKUgwHeyCf1kUjPI7sdVXxGS2cBTVHsAoF5AaoBb2H_9qGRfQfl2f3D7S3mmGhMP6W_8tvPvTaiHdPTDcgw9v.mXVGPw--
X-Mailer: YahooMailRC/651.50 YahooMailWebService/0.7.134
Date: Tue, 11 Sep 2007 22:39:21 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: Do not deprecate binary semaphore or do allow mutex in software interrupt contexts
To: Arjan van de Ven <arjan@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <698652.90161.qm@web52004.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following code seems to me to be a valid example of a binary semaphore (mutex) in a timer:

//timer called 10 times a second 
static void status_timer(unsigned long device)
{
    struct etp_device_private *dp = (struct etp_device_private *)device;
    if (unlikely(dp->status_interface == 0))
        dp->status_interface = INTERFACES_PER_DEVICE - 1;
    else
        dp->status_interface--;
    //DBG_PRINT ("%s: In status timer, interface:0x%x.\n",etp_NAME, dp->status_interface);
    idt_los_interrupt_1(dp, dp->status_interface);
    if (likely(!dp->reset))
        // reset the timer:
        mod_timer(&dp->status_timer, jiffies + HZ / 10);
}

static inline void read_idt_register_interrupt(struct etp_device_private *dp,
                           unsigned reg)
{
    DBG_PRINT("read_idt_register_interrupt to mutex_lock.\n");
    if (unlikely(down_trylock(&dp->semaphore)))
        return;        /* Do not read because failed to lock. */
    if (likely
        (!dp->status
         && !(inl((void *)(dp->ioaddr + REG_E1_CTRL)) & E1_ACCESS_ON))) {
        outl(((reg << E1_REGISTER_SHIFT) & E1_REGISTER_MASK)
             | E1_DIR_READ | E1_ACCESS_ON,
             (void *)(dp->ioaddr + REG_E1_CTRL));
        dp->status = 1;
        DBG_PRINT("read_idt_register_interrupt set status read.\n");
    } else
        DBG_PRINT
            ("read_idt_register_interrupt did not set status %u read.\n",
             dp->status);
    DBG_PRINT
        ("read_idt_register_interrupt do not wait for result here, read in tasklet.\n");
}


//for getting los information with interrupt:

void idt_los_interrupt_1(struct etp_device_private *dp, unsigned interface)

{

    read_idt_register_if_interrupt(dp, E1_TRNCVR_LINE_STATUS0_REG,

                       interface);

}


static void e1_access_task(unsigned long data)    //called after e1_access_interrupt
{
    struct etp_device_private *dp = (struct etp_device_private *)data;
    struct etp_interface_private *ip;
    unsigned int interface, error;
    bool los;

    //check if los status was read:
    if (unlikely(!dp->status)) {
        DBG_PRINT("e1_access_task wakes up user.\n");
        wake_up(&dp->e1_access_q);
        return;
    }
    error =
        idt_los_interrupt_2(dp->ioaddr, &interface, &los,
                dp->pci_dev->device);
    //DBG_PRINT ("%s: In e1 task, error:0x%x, interface:0x%x, los:0x%x.\n",
    //         etp_NAME, error, interface, los);
    dp->status = 0;
    up(&dp->semaphore);
    DBG_PRINT("e1_access_task got error %u.\n", error);
    if (unlikely(error))
        return;
    //update los status:
    ip = &dp->interface_privates[interface];
    ip->los = los;
    //update status:
    if ((ip->if_mode == IF_MODE_CLOSED) ||    //interface closed or
        (ip->los)) {    //link down 
        set_led(LED_CTRL_OFF, ip);
        if (netif_carrier_ok(ip->ch_priv.this_netdev))
            netif_carrier_off(ip->ch_priv.this_netdev);
    } else {        //link up and interface opened
        if (!netif_carrier_ok(ip->ch_priv.this_netdev))
            netif_carrier_on(ip->ch_priv.this_netdev);
        if (ip->if_mode == IF_MODE_HDLC) {
            set_led(LED_CTRL_TRAFFIC, ip);
        } else {    //ip->if_mode == IF_MODE_TIMESLOT
            set_led(LED_CTRL_ON, ip);
        }
    }
}

int idt_los_interrupt_2(u8 * ioaddr, unsigned *interface, bool * los,
            unsigned pci_device_id)
{                //returns 0 in success
    unsigned int value = inl((void *)(ioaddr + REG_E1_CTRL));
    //if access not ended:
    if (value & E1_ACCESS_ON) {
        return 1;
    }
    //if access not to los status register 
    if ((value & E1_REGISTER_MASK_NO_IF) !=
        (E1_TRNCVR_LINE_STATUS0_REG << E1_REGISTER_SHIFT)) {
        return 1;
    }
    //get interface
    *interface =
        idt_if_to_if((value & E1_REGISTER_MASK_IF) >>
             E1_REGISTER_SHIFT_IF, pci_device_id);
    *los = value & 0x1;
    return 0;
}

int write_idt_register_lock(unsigned device, unsigned reg, u32 value)
{
    struct etp_device_private *etp = get_dev_priv(device);
    unsigned ctrl;
    DBG_PRINT("write_idt_register_lock to mutex lock device %u.\n", device);
    down(&etp->semaphore);
    if (unlikely(etp->reset)) {
        up(&etp->semaphore);
        DBG_PRINT
            ("write_idt_register_lock device %u unusable.\n", device);
        return -ENXIO;
    }
    DBG_PRINT("write_idt_register_lock mutex locked device %u.\n", device);
    do {
        DBG_PRINT
            ("write_idt_register_lock to wait_event_timeout device %u.\n",
             device);
        wait_event_timeout(etp->e1_access_q,
                   !((ctrl =
                      inl((void *)(etp->ioaddr + REG_E1_CTRL)))
                     & E1_ACCESS_ON), HZ / 500);
    }
    while (ctrl & E1_ACCESS_ON);
    DBG_PRINT("write_idt_register_lock to outl device %u.\n", device);
    outl(((reg << E1_REGISTER_SHIFT) & E1_REGISTER_MASK) |
         E1_DIR_WRITE | E1_ACCESS_ON | (value & E1_DATA_MASK),
         (void *)(etp->ioaddr + REG_E1_CTRL));
    up(&etp->semaphore);
    DBG_PRINT("write_idt_register_lock mutex unlocked device %u.\n",
          device);
    return 0;
}
        Copyright (C) 2006 Jouni Kujala, Flexibilis Oy.




      __________________________________  
Alles was der Gesundheit und Entspannung dient. BE A BETTER MEDIZINMANN! www.yahoo.de/clever
