Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977Ab0AYX2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0AYX2M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 18:28:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399Ab0AYX2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 18:28:11 -0500
Received: from mail-pz0-f189.google.com ([209.85.222.189]:64702 "EHLO
	mail-pz0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab0AYX2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 18:28:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iBja69cUlJ/1DDNPOTnp7R5X9FyGMIehhkIb+nGIm/a3w/pPTUgw/B3cMfCEwlH/44
         2rtg/khm58Awcma3sfmXJ/mmsTJbabjE/ai8K3a9PXEFyAT4gtyI+qnKy5zhqP+XvtFm
         wdTYP0g3vXSITvzqV6PKcbYppCqjDfb6K5QJE=
Date: Mon, 25 Jan 2010 15:28:01 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Vojtech Pavlik <vojtech@suse.cz>, Robert Hancock <hancockrwd@gmail.com>,
       Bastien Nocera <hadess@hadess.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, pjones@redhat.com
Subject: Re: [PATCH] Disable i8042 checks on Intel Apple Macs
Message-ID: <20100125232801.GD30307@core.coreip.homeip.net>
References: <4B57A2D4.9030204@gmail.com>
 <20100121185544.GB11996@core.coreip.homeip.net>
 <51f3faa71001211339t4652700ct34659c37479cd67e@mail.gmail.com>
 <20100121221701.GA15293@core.coreip.homeip.net>
 <20100125163433.GB31957@suse.cz>
 <4B5E0DFA.8080705@zytor.com>
 <20100125221520.GA30307@core.coreip.homeip.net>
 <4B5E18C0.7060402@zytor.com>
 <20100125223004.GB30307@core.coreip.homeip.net>
 <4B5E23BB.1090806@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5E23BB.1090806@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 25, 2010 at 03:05:31PM -0800, H. Peter Anvin wrote:
> On 01/25/2010 02:30 PM, Dmitry Torokhov wrote:
> >>
> >> We should never read from port 0x60 unless bit 1 in port 0x64 is set.
> >> Do we do that?
> > 
> > No, we don't read of OBF is 0. Incidentially 0xff has it set ;) so we do
> > try reading data port.
> > 
> 
> What do you do after reading the data port?  In the case of the A20
> code, we do dummy reads and loop until the data port drains (0xff of
> course means it never drains...)
> 

/*
 * i8042_flush() flushes all data that may be in the keyboard and mouse
 * buffers
 * of the i8042 down the toilet.
 */

static int i8042_flush(void)
{
        unsigned long flags;
        unsigned char data, str;
        int i = 0;

        spin_lock_irqsave(&i8042_lock, flags);

        while (((str = i8042_read_status()) & I8042_STR_OBF) && (i < I8042_BUFFER_SIZE)) {
                udelay(50);
                data = i8042_read_data();
                i++;
                dbg("%02x <- i8042 (flush, %s)", data,
                        str & I8042_STR_AUXDATA ? "aux" : "kbd");
        }

        spin_unlock_irqrestore(&i8042_lock, flags);

        return i;
}

...

static int i8042_controller_check(void)
{
        if (i8042_flush() == I8042_BUFFER_SIZE) {
                printk(KERN_ERR "i8042.c: No controller found.\n");
                return -ENODEV;
        }

        return 0;
}

-- 
Dmitry
