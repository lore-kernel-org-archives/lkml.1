Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbZBYJvC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbZBYJvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 04:51:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756103AbZBYJuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 04:50:51 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:58471 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755995AbZBYJuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 04:50:50 -0500
Date: Wed, 25 Feb 2009 10:50:46 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Mark Nelson <markn@au1.ibm.com>
cc: "Sachin P. Sant" <sachinp@in.ibm.com>, Jan Kara <jack@ucw.cz>,
       Jan Kara <jack@suse.cz>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org
Subject: Re: Crash (ext3 ) during 2.6.29-rc6 boot
In-Reply-To: <200902251752.56514.markn@au1.ibm.com>
Message-ID: <alpine.LRH.2.00.0902251018060.4063@vixen.sonytel.be>
References: <49A2705D.9030008@in.ibm.com> <20090223155116.GB5764@atrey.karlin.mff.cuni.cz> <49A395ED.5030607@in.ibm.com> <200902251752.56514.markn@au1.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Feb 2009, Mark Nelson wrote:
> On Tue, 24 Feb 2009 05:38:37 pm Sachin P. Sant wrote:
> > Jan Kara wrote:
> > >   Hmm, OK. But then I'm not sure how that can happen. Obviously, memcpy
> > > somehow got beyond end of the page referenced by bh->b_data. So it means
> > > that le16_to_cpu(entry->e_value_offs) + size > page_size. But
> > > ext3_xattr_find_entry() calls ext3_xattr_check_entry() which in
> > > particular checks whether e_value_offs + e_value_size isn't greater than
> > > bh->b_size. So I see no way how memcpy can get beyond end of the page.
> > >   Sachin, is the problem reproducible? If yes, can you send us contents
> > >   
> > Yes, i am able to recreate this problem easily. As i had mentioned if the
> > earlier kernel is booted with selinux enabled and then 2.6.29-rc6 is booted
> > i get this crash. But if i specify selinux=0 at command line, 2.6.29-rc6 boots
> > without any problem.
> 
> Hi Sanchin and Geert,
> 
> Does the patch below fix the problems you're seeing? If it does I'll send
> a properly written up and formatted patch to linuxppc-dev (as well as
> another one to fix the same problem in copy_tofrom_user()).

Unfortunately not, now it crashes while accessing the memory pointed to by
GPR16, in

NIP: copy_page_range+x0608/0x628
LR:  dup_mm+0x2e4/0x428
Trace: debug_table+0xcc70/0x1afe0 (unreliable)
dup_mm+0x2e4/0x428
copy_process+0x86c/0xf9c
do_fork+0x188/0x39c
sys_clone+0x58/0x70
ppc_clone+0x8/0xc

However, after reverting 25d6e2d7c58ddc4a3b614fc5381591c0cfe66556, I still see
similar problems as above (crash in copy_page_range()).
Which makes me think that
  1. Your new patch fixes the problem introduced by 25d6e2d7,
  2. There's still another issue than the one introduced by 25d6e2d7.

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
