Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYHUGEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYHUGEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 02:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755974AbYHUGEB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 02:04:01 -0400
Received: from n5a.bullet.mail.ac4.yahoo.com ([76.13.13.68]:27870 "HELO
	n5a.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755884AbYHUGD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 02:03:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 366917.98286.bm@omp119.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Message-ID;
  b=cirCEjGxbjE/6HIyhjttO+lMnk+TPo7bBNyQifkveACvok0IlhEdZ1mqmb7XOBFYBfB4Y8uIlVWSPt0CIjtJ27/mBrrZD9tX2tzUr1lYo/gz3XqObFskcmRZwZ0In9nysBlz1wSEfsM/r2T2uttJh6azgZrP5nMOsg5DL5JjBSs=;
X-Mailer: YahooMailWebService/0.7.218
Date: Wed, 20 Aug 2008 23:03:57 -0700 (PDT)
From: amruth <amruth_pv@yahoo.com>
Reply-To: amruth_pv@yahoo.com
Subject: USB Serial device disconnect causes IRQ disable
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200808210719.03925.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <649688.7131.qm@web45210.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Oliver

> What happens when you never plug in the device?
Everything works fine without plugging the device. I have memory stick 
which never creates any problem.

> I think you have another device causing interrupts whose
> driver doesn't handle them. While the usb host controller is
> busy due to your device, it generates enough interrupts to keep the
> logic for detection of spurious interrupts happy. When you unplug
> your device you get too many unhandled interrupts.

I understand the problem because I have 2 devices using the same driver.
One device requies only to read from bulk in pipe and other gets null packet interrupt followed by bulk in read to get data.

Previously I did only bulk in read for both the devices and no handler for interrupt.
When I use together, there is flooding of interrupts coming from the device but unhandled by the driver.

I need to separate out both the logics one for interrupt the other to get bulk pipe to read data directly.

Thanks Oliver for pointing the issue, I never understood why it happened but I see the data being read from bulk in pipe irrespective of handling interrupts which means we need to read interrupts otherwise spurious interrupts logic detects it and disables the USB bus 

I have another issue where I need to stop the bulk in read callback when it no longer has data to give to the application because the data length is dynamic. I see that we continue to read without even data in the urb.

 /* Continue to read if we have still urbs to do. */
                    port->read_urb->dev = port->serial->dev;
                 result = usb_submit_urb(port->read_urb, GFP_ATOMIC);
                 if (result)
                         err("%s - failed resubmitting read urb, error %d", __FUNCTION__, result);
                 dbg("%s - usb_submit_urb(read urb)", __FUNCTION__);

This logic is used in all drivers.
After close is called in the application, the driver continues to call read_bulk_in callback  function which continues to read and the error
"failed resubmitting read urb" is displayed. 

This particular functions below in close does not kill read_urb and hence the bulk in call back continues to read.
                    usb_kill_urb(port->write_urb);
                    usb_kill_urb(port->read_urb);

How to effectively stop urbs submitting read request into USB when no longer data is ther in the transfer buffer.
Thanks
Amruth p.v


--- On Thu, 8/21/08, Oliver Neukum <oliver@neukum.org> wrote:

> From: Oliver Neukum <oliver@neukum.org>
> Subject: Re: USB Serial device disconnect causes IRQ disable
> To: amruth_pv@yahoo.com
> Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
> Date: Thursday, August 21, 2008, 12:19 AM
> Am Donnerstag 21 August 2008 02:18:37 schrieb amruth:
> > Hi
> > I don't have any driver modules. I have everything
> built into kernel.
> > When can this kind of IRQ disable happen, what causes
> this. The issue happened because of hotplugging my device
> but the device works fine.
> > usb_register(driver) might have caused the issue. How
> do we debug this problem.
> 
> What happens when you never plug in the device?
> I think you have another device causing interrupts whose
> driver
> doesn't handle them. While the usb host controller is
> busy due
> to your device, it generates enough interrupts to keep the
> logic
> for detection of spurious interrupts happy. When you unplug
> your
> device you get too many unhandled interrupts.
> 
> 	Regards
> 		Oliver
> --
> To unsubscribe from this list: send the line
> "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at 
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


      

