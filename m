Return-Path: <linux-kernel-owner+w=401wt.eu-S1756919AbYDBPOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756919AbYDBPOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755077AbYDBPOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:14:37 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:6925 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbYDBPOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:14:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=from:organization:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=SZZwTiWYbqjLgcVU5w0JAVsJfevdH3s6J1SRr6WU0BHA0z7xvLqlUnr/LN8xNHgu5DHRDUyH5IXcDJUQBeRp22pbPt361J5AkGwsCXGAqR4+T3NRCGy6ygPt8YBG0NGujEcp508Nhv+XFaLBHTSd2btQESQW/e2YxlvabcFFKD8=
From: Balaji Rao <balajirrao@gmail.com>
Organization: National Institute of Technology, Karnataka
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.25-rc5.git4 regression PS/2 mouse not detected/working
Date: Wed, 2 Apr 2008 20:38:33 +0530
User-Agent: KMail/1.9.6 (enterprise 0.20071012.724442)
Cc: Yanko Kaneti <yaneti@declera.com>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       Thomas Gleixner <tglx@linutronix.de>
References: <1205775229.25146.11.camel@indigo.declera.com> <1207091851.3306.6.camel@d2> <20080402105253.ZZRA012@mailhub.coreip.homeip.net>
In-Reply-To: <20080402105253.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804022038.33245.balajirrao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 April 2008 08:29:00 pm Dmitry Torokhov wrote:
> Hi Yanko,
> 
> On Wed, Apr 02, 2008 at 02:17:31AM +0300, Yanko Kaneti wrote:
> > On Tue, 2008-03-18 at 11:54 -0400, Dmitry Torokhov wrote:
> > > On Mon, Mar 17, 2008 at 08:58:43PM +0200, Yanko Kaneti wrote:
> > > > On Mon, 2008-03-17 at 14:55 -0400, Dmitry Torokhov wrote:
> > > > > On Mon, Mar 17, 2008 at 07:33:49PM +0200, Yanko Kaneti wrote:
> > > > > >
> > > > > > My PS/2 mouse stops being detected between kernels 2.6.24.3-12.fc8 
and
> > > > > > 2.6.25-0.121.rc5.git4.fc9 (which I believe do not carry any 
patches in
> > > > > > that area). Its an ASUS P5E-VM DO motherboard , bios revision 
0506. The
> > > > > > PS/2 keyboard still works.
> > > > > > 
> > > > > > Attached are both dmesg logs with i8042.debug=1, dmidecode, 
lspci -vvnn
> > > > > > Tried i8042.noloop and both the mouse and keyboard stop working.
> > > > > > 
> > > > > 
> > > > > Could you please send me dmesg from booting with i8042.noloop. I 
would
> > > > > expect this option to help in your case so I am curious what went 
wrong.
> > > > 
> > > > Attached
> > > > 
> > > 
> > > Hmm, it looks the kernel does the right thing in case of i8042.noloop,
> > > except that it does not work :(. Kernel triest to query the mouse but
> > > it does not respond.
> > > 
> > > Can you try taking contents of drivers/input/serio from 2.6.25 and
> > > copy it in .24? It will most likely compile... If that works I'm
> > > afraid I will ahve to ask you to do git biscect to find the offending
> > > commit.
> > 
> > Hey again,
> > 
> > I finally did the bisecting. It found the cuplrit to be
> > 
> > commit e3f37a54f690d3e64995ea7ecea08c5ab3070faf
> > Author: Balaji Rao <balajirrao@gmail.com>
> > Date:   Wed Jan 30 13:30:03 2008 +0100
> > 
> >     x86: assign IRQs to HPET timers
> >     
> > 
> > I tried reverting the change on the latest git with the attached patch
> > and my mouse and keyboard appear to be detected and working fine now.
> > The patch had to be stiched by hand and due to my lack of understanding
> > of the code might be breaking random other stuff.
> > 
> > FWIW the bios on this board has no knobs for HPET that I could find.
> > 
> > What gives?
> > 
> 
> Hmm, this is wierd and really outsize of my knowledge... Lets try copying
> Ingo, Thomas and Balaji, maybe they can help us out here.
> 
> Btw, what is in your /proc/interrupts?
> 
Hi,

Coincidentally even I hit upon this bug a couple of days ago after enabling 
HPET in my BIOS. A quick check told me that IRQ 12 which the patch assigns to 
the HPET device is used by the PS/2 mouse as well. This makes the mouse 
inactive.

I am working on this.. I am not sure if the PS/2 code is misbehaving though..

-- 
regards,
Balaji Rao
Dept. of Mechanical Engineering,
National Institute of Technology Karnataka, India
