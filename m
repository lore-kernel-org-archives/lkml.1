Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbYDIReP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbYDIReP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 13:34:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYDIReB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 13:34:01 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:17156 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYDIReA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 13:34:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=biJXLAJMtVN5FPsO1g672JzoG6TL23Zad3GgZOIuY20YnzPn07Z/b4fTThGWb0QTUoVUtr16ltkoPVQoh5mh0EsLVU7UYjUYkH1pJxwJp5lrV7pItSdmQopn1SKUBiyl7N6VVhStp9jYJM9wRBnQWu85jB/zAATlcJIYW+lL124=
Message-ID: <a5eaedfa0804091033t1365f3a2jf1f08ab257cd4e2b@mail.gmail.com>
Date: Wed, 9 Apr 2008 23:03:58 +0530
From: "Veda N" <veda74@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: wait interruptible does not work
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am having a kernel thread that waits on a completion object.

I am also having an ISR that wakes up the thread when ever an interrupt occurs.
The thread calls wait_completion_interruptible and waits for "completion" event.

What is happening is Even though i get the interrupt - The ISR calls 'complete'

The Thread does not wakeup.

I dont know why?.

I notice that i replaced wait_completion_interruptible with
wait_completion_timeout.

What happens is i keep getting the messages. As soon as the ISR
triggers the completion event. The threads stops/gets killed.

I dont know whats happening.


Could anyone help me on this.

Appending my code

Regards,
veda



#include <linux/module.h>
#include<linux/init.h>
#include <linux/device.h>
#include <linux/platform_device.h>
#include <linux/interrupt.h>
#include <linux/kthread.h>
#include <asm/arch/gpio.h>
#include <linux/delay.h>

MODULE_AUTHOR("Newbee");
MODULE_DESCRIPTION("Wait Interruptible Demo Driver");

static int r_init(void);
static void r_cleanup(void);

module_init(r_init);
module_exit(r_cleanup);


static int information = 0x100;
static int id = 99;
static struct completion touch_completion;
static struct completion thread_comp;
struct task_struct *kthread;

int printmsgd(void *param);

static irqreturn_t attn_isr( int irq, void *info)
{
        printk ("Got an Interrupt\n");

        complete(&touch_completion);
}

static int r_init(void)
{
        int retval;
        init_completion(&touch_completion);
        init_completion(&thread_comp);
        if(omap_request_gpio( 140 ) < 0)
        {
                printk("Error: failed to request gpio\n");
        }

        printk ("interrupt mode...\n");
        omap_set_gpio_direction( 140, 1);

        if(( retval = request_irq(OMAP_GPIO_IRQ(140), attn_isr,
                     IRQF_TRIGGER_LOW, "test-irq", &information )))
        {
                printk ("Error: Unable to do request irq\n");
                return -1;
        }

        kthread = kthread_run(&printmsgd, &id, "printmsgd");

        printk ("kthread run:%x\n", kthread);


        return 0;
}

static void r_cleanup(void)
{
        complete(&touch_completion); /* Kick the thread awake */
        if (kthread) wait_for_completion(&thread_comp);
        return ;
}

int printmsgd(void *param)
{
        int ret;

//      daemonize("printmsgd");

        while (!kthread_should_stop()) {
                ret = wait_for_completion_interruptible(&touch_completion);
                printk ("printmsgd says hi:%d\n", ret);
        }
        complete_and_exit(&thread_comp, 0);
}
