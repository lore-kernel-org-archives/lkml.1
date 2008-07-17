Return-Path: <linux-kernel-owner+w=401wt.eu-S1758303AbYGQJvw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758303AbYGQJvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 05:51:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754183AbYGQJvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 05:51:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:29631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972AbYGQJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 05:51:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Z5/q41YKOR+Vp5HjkCukRgefwJj/RHuLoHOPOAk7/vDMagV1/q0RXarFspn+6jj7F9
         cGllKt81UMD6mGcJHKKdcIm7dckuir46iIUVnv4usNMwEva+GN3FxJwoXScXc5lzzoOH
         XS13bn/VvS9qFVJ8dv/H9iwlF6jjwMBf22+T8=
Date: Thu, 17 Jul 2008 13:48:58 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jean Delvare <khali@linux-fr.org>, john stultz <johnstul@us.ibm.com>,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Linux I2C <i2c@lm-sensors.org>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [crash, bisected] I2C,  kobject (ffff81003e8c4160): tried to
	init an initialized object
Message-ID: <20080717094858.GA18687@martell.zuzino.mipt.ru>
References: <20080714224945.629446fa@hyperion.delvare> <20080716082352.GA30483@elte.hu> <20080716110702.3ca61eb2@hyperion.delvare> <20080716120801.3e9b4c80@hyperion.delvare> <20080716141826.1d88d05e@hyperion.delvare> <20080717092655.GA6115@elte.hu> <20080717093329.GA20032@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080717093329.GA20032@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:33:30AM +0200, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > Jean,
> > 
> > -tip testing found another (similar) i2c crash with latest -git, on a 
> > Core2Duo laptop:
> > 
> > calling  nforce2_init+0x0/0x1b
> > initcall nforce2_init+0x0/0x1b returned 0 after 0 msecs
> > calling  nforce2_s4985_init+0x0/0x275
> > BUG: unable to handle kernel NULL pointer dereference at 0000000c
> > IP: [<c04af2cf>] i2c_smbus_xfer+0x27/0x3f0
> > *pdpt = 00000000009cb001 *pde = 0000000000000000 
> > Oops: 0000 [#1] SMP 
> 
> turning off I2C_NFORCE2_S4985 makes the system boot up fine. Workaround 
> patch below.

Well, it's pretty easy oops unless I misread something.

It happened on not nforce2 motherboard, right?

nforce2_init will just register PCI driver,
no matching PCI ids => nforce2_set_reference() isn't called =>
nforce2_smbus stays NULL.

Second module loads and tries to i2c_smbus_xfer(NULL, ) in module_init()
hook which oopses.

