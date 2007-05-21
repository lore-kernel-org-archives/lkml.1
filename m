Return-Path: <linux-kernel-owner+w=401wt.eu-S1762637AbXEUPFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762637AbXEUPFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 11:05:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbXEUPFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 11:05:10 -0400
Received: from mail.technord.be ([194.78.28.186]:12330 "EHLO mail.technord.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754696AbXEUPFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 11:05:08 -0400
X-Greylist: delayed 856 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 May 2007 11:05:08 EDT
Message-ID: <4651BEFD.2080700@technord.com>
Date: Mon, 21 May 2007 17:47:09 +0200
From: alain meirhaeghe <ame@technord.com>
User-Agent: Thunderbird 1.5.0.8 (X11/20061107)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: module i2c_pca_isa PC9564, interrupt problem
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2007 14:50:45.0623 (UTC) FILETIME=[6997E070:01C79BB7]
X-TM-AS-Product-Ver: SMEX-7.0.0.1345-3.6.1039-15184.001
X-TM-AS-Result: No--11.584800-8.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I think there is a bug in i2c_pca_isa driver.
Problem is interrupt running on arm720 system linux-2.6.20.1.

Description of the problem:
When driver write to pc9564 an infinite loop interrupt appear (bloquing 
the system).


J think it is because the acknowledge of interrupt is not do correctly.
Acknowledge of interrupt is done outside interrupt .
J think it is dangerous if latency time of interrupt is short (as in ARM 
processor).

See existing code below:
static int pca_isa_waitforinterrupt(struct i2c_algo_pca_data *adap)
{
    int ret = 0;
    if (irq > -1)
    {
        ret = wait_event_interruptible(pca_wait,pca_isa_readbyte(adap, 
I2C_PCA_CON) & I2C_PCA_CON_SI);
      
    } else
    {
        while ((pca_isa_readbyte(adap, I2C_PCA_CON) & I2C_PCA_CON_SI) == 0)
            udelay(100);
    }
    return ret;
}

static irqreturn_t pca_handler(int this_irq, void *dev_id) {
   
    wake_up_interruptible(&pca_wait);
    return IRQ_HANDLED;
}

Isa_wait is never waked because pca_handler is always call, because j 
think it is necessary to acknowledge the interrupt in the interrupt 
handler as usual.
My temporary solution is:
static irqreturn_t pca_handler(int this_irq, void *dev_id) {
    disable_irq(irq);   // !!!!!!!!!!!!!!!!!!! temporary patch
    wake_up_interruptible(&pca_wait);
    return IRQ_HANDLED;
}



How can we correct this  ?

Thank to all
Alain Meirhaeghe




