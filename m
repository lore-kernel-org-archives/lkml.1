Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZCAI7E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZCAI7E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 03:59:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753024AbZCAI6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 03:58:55 -0500
Received: from web110616.mail.gq1.yahoo.com ([67.195.13.207]:24107 "HELO
	web110616.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752277AbZCAI6z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 03:58:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:References:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=LW/HcdhBdmcusaJP9iobCiynA+VTVS4cnF7ICTu5mZo7HELOq4Egkcs2rwq2vFeYHiRfSVFpxPEr7Kp/AU39reG2D6VDyPcEStp6VxJV1jk/vvwvYr/vUXMW4IYL4fN0lhTNDoVzu8GTG8nGpZsn9coSP9FyM7Bda8IvRRjou9A=;
Message-ID: <134099.98473.qm@web110616.mail.gq1.yahoo.com>
X-YMail-OSG: hzlVVJQVM1mWBGZqBIoznKuhkwKHrFgZbGOzag3XQermG19UtqC.LQvdnbebxCurN6k2KNdD_Cj86.8UHF3tLPFJ8jhEryicbseHeD0.Gp9vrv3M9UpSXCckPy9z1PNf00Ttpy.JDpivVF9oUQ2KCRRC.izoErnfQ2Q1RamIR75PUD3CC_IXLLiDa_TOHBrhWRHgp5V1fYO91mw8rgn6he1GAJJhBBkUGnQkZPbvTPLJZ6sXPVm8TfWUmEmL0EzoXIdbXVGrsC.V99GvadK6hOgJagnK7g--
X-Mailer: YahooMailRC/1155.45 YahooMailWebService/0.7.289.1
References: <20090301002758.GA23465@silver.sucs.org> <19f34abd0903010039t23d669bck476066e571a316e@mail.gmail.com>
Date: Sun, 1 Mar 2009 00:58:52 -0800 (PST)
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: kmemcheck warnings (con_font_op, fuse_open_common)
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hello,

> From: Vegard Nossum <vegard.nossum@gmail.com>

> 
> 2009/3/1 Sitsofe Wheeler :
> > Hi,
> >
> > I've run kmemcheck with the latest -tip and most of the warnings I was
> > getting have now died down. However dmesg seems to have warnings that
> > look somewhat legitimate now (and there are quite a few). Further after
> > a suspend to ram/resume one particular warning related to worker_thread
> > started appearing over and over. For now I've attached a slightly
> > modified dmesg below to see what you think:
> 
> You did suspend to ram/resume with kmemcheck!? And it worked? WOW! :-D

No one told me it wasn't supposed to work so... :D

> > [  311.779612]  [] copy_to_user+0x3e/0x60
> > [  311.780335]  [] con_font_op+0x290/0x3f0
> 
> This one is very likely a real information leak, because it does a
> copy to userspace (and the only way this can . On the other hand, the
> memory _does_ look like it's been initialized (all 0xff). IIRC, I
> tracked this one down to an overlong copy in vgacon before. But I'd
> have to look at it again...

For some reason I am sure that you had tracked this down before too. I think
I confused this with the drm patch you sent a few months ago in one of my
earlier emails.
 
> > [  312.284408] Pid: 952, comm: usplash Not tainted 
> (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> > [  312.284418] EIP: 0060:[] EFLAGS: 00013002 CPU: 0
> > [  312.284433] EIP is at __dequeue_signal+0xb7/0x140
> 
> This is in general a false positive. This case looks a little
> different from what I've seen here, though.

OK now I'm aware I will avoid bringing this type of message up in 
the future.

> > [ 1795.445139] Pid: 3898, comm: gvfs-fuse-daemo Not tainted 
> (2.6.29-rc6-tip-02247-gf8dda9e #68) 900
> > [ 1795.445146] EIP: 0060:[] EFLAGS: 00010246 CPU: 0
> > [ 1795.445159] EIP is at fuse_file_alloc+0x69/0x90
> 
> Hm. This is a false positive too. RB_CLEAR_NODE() will do a read on
> the uninitialized value before writing back the new parent pointer
> (colour remains uninitialized, however). I suspect that we could get
> away with changing RB_CLEAR_NODE() to just set the colour to 0 at the
> same time.

I have to admit I was struggling with this one for a long time. I was sure
that ff could not be uninitialized if it wasn't NULL :)
 
> Thanks for the report! I will try to fix the false positives (by
> annotating the code paths in question), and investigate the rest. It's
> a bit sad to see that we (still) have such a high false-positive rate,
> but it can't really be helped.

It sounds like a tricky business (plus I would guess that only the major paths
will wind up annotated even though drivers could really benefit from this). The
problem is that in the hands of inexpert users (such as myself) there is a strong
desire to simply report every kmemcheck warning and leave someone else to 
understand if it is legit. I'm trying to get a feel (purely based on the look of the 
stacktrace, whether the memory is initialized at all and frequency of the error) 
so that intuitively I am less likely to report false positives. Your guide (especially
the bit mentioned addr2line) has been really helpful too.



      
