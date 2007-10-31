Return-Path: <linux-kernel-owner+w=401wt.eu-S1757890AbXJaNdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890AbXJaNdp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 09:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbXJaNdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 09:33:37 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:28290 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158AbXJaNdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 09:33:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=KWSm816RPPCwLyF4JZMUSean5yV9m40dg8DKJQ6vambhygLn+C8R5slSf2we7Dn2/hjWtvjwjd1lvOx3D4yZDBLqqfvHXdvSmct8x/n26KpVPDsV1AxLn7+ILLNHCNnei0abZMbtpHHoGF5+hqxwJHb6wZ9/w7fuNiOcSdG7DBE=
Date: Wed, 31 Oct 2007 15:33:40 -0700
To: stuart.menefy@st.com
Cc: Paul Mundt <lethal@linux-sh.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linuxsh <linuxsh-dev@lists.sourceforge.net>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: [SUPERH / PATA / SCSI] Unable to do start userland after kernel
 boot (BISECTED)
Message-Id: <20071031153340.2beec5ab.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071031025621.a9f3f880.Kristoffer.ericson@gmail.com>
References: <20071025212240.a50c18b6.Kristoffer.ericson@gmail.com>
	<20071025194618.GA26344@linux-sh.org>
	<20071031025621.a9f3f880.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 02:56:21 -0700
Kristoffer Ericson <Kristoffer.ericson@gmail.com> wrote:

> On Fri, 26 Oct 2007 04:46:18 +0900
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > On Thu, Oct 25, 2007 at 09:22:40PM -0700, Kristoffer Ericson wrote:
> > > The bottom line seems to be that it fails to attach scsi sg0. It
> > > explains why it doesn't work, but not why it stopped working. And this
> > > has nothing to do with the current kernel config, I've been over that
> > > the last 4 days. It all started when I synced my jlime-current.git
> > > repository with linux-2.6.git. As you can see I had 2.6.23-rc6 and then
> > > synced up to 2.6.23-rc8/rc9 and thats when the troubles started.
> > > 
> > At least that suggests it's not fallout from the INTC changes in -rc1, so
> > that helps to narrow it down a bit. Since you have a known good and bad,
> > it would be nice if you could bisect this to figure out what exactly
> > caused the regression. There weren't any SH-specific changes between rc6
> > and rc8/rc9 at least.

Just wanted to confirm that when reverting the patch below my kernels start booting again. Bisect is a pain to go through, but is really effective.

> 
> I've spent a couple of hours bisecting it, and this is where it stops working. I haven't reversed the patch yet, simply because Im dead tired :D Will do that tommorow, but Im quite confident that this is the correct bug.
> 
> 023ef184fff6ac2e7cba345708f35536a2a419cb is first bad commit
> commit 023ef184fff6ac2e7cba345708f35536a2a419cb
> Author: Stuart Menefy <stuart.menefy@st.com>
> Date:   Fri Sep 28 12:36:35 2007 +0900
> 
>     sh: __copy_user() optimizations for small copies.
>     
>     This implements a fast-path for small (less than 12 bytes) copies,
>     with the existing path treated as the slow-path and left as the default
>     behaviour for all other copy sizes.
>     
>     Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
>     Signed-off-by: Paul Mundt <lethal@linux-sh.org>
> 
> :040000 040000 43f62cf05d1f71a5564b232dfd9e8492af909a90 4ab51dc5b85bc9bc86d58331845e525a67751be8
> 
> My bisect log:
> *START_ BAD     -   _CURRENT_                                                   30 October              "No Init found"
> BAD     -   b5869ce7f68b233ceb81465a7655be0d9a5f3dbb    "Merge git://..sched"   15 October              "No Init found"
> BAD     -   f248488b397d52717f6683e2e53200aa687ffc89    "merge infradead.org"   14 October              "No Init found"
> BAD     -   3749c66c67fb5c257771815c186bc32290cacf44    "merge git/avi/kvm"     13 October              "No Init found"
> BAD     -   dcf397f037f52add9945eced57ca300ab6a4413c    "merge sh-2.6"          13 October              "No Init found"
> BAD     -   5d9df8eeacec943c9599f1cfd1069bc8cced3de6    "sh: Fix SH-4 DMAC.."   "8 October"             "No Init found"
> BAD     -   e5137682a1ad48bc5306070935c277e262f119ef    "sh: Tidy up gUSA .."   "28 September"          "No Init found"
> BAD     -   023ef184fff6ac2e7cba345708f35536a2a419cb    "sh: __copy_user().."   "28 September"          "No Init found"
> GOOD    -   24eb17e0813490497f4d5b2fad218bdba402cece    "sh: clkfwk: Support."  "28 September"          "WORKS!"
> GOOD    -   cb7af21f7d370edb3a6a6d3e15cb17c8fd61591e    "sh: Use boot_cpu_d."   "27 September"          "WORKS!"
> GOOD    -   c167aeef232c45deaf5c6c9be00a1f71b14962d3    "sh: Kill off dupl.."   "27 September"          "WORKS!"
> GOOD    -   1db4e9bb5682fd3fd3f37f7fe9c322e7c5bb7578    "sh: don't enable.."    "11 September"          "WORKS!"
> GOOD    -   ab9c232286c2b77be78441c2d8396500b045777e    "Merge..libata-dev"     12 October              "WORKS!"
> GOOD    -   ce9d3c9a6a9aef61525be07fe6ba27d937236aa2    "Merge-br.. for linux"  11 October              "WORKS!"
> GOOD    -   d85f57938ad1d674dff8077a2e6a36a45dbe0e22    "Merge branch 'master'" 26 Sept                 "WORKS!"
> GOOD    -   2aee6198652b32e5eaef29a8f8330a9dd15b8efd    "fixes-jgarzik"         25 Sept                 "WORKS!"
> GOOD    -   f3d5e3a4155b6f42f6f6f0a2cc95ca0adbabe1af    "[PPP] L2TP: Fix ..     19 Sept                 "WORKS!"
> GOOD    -   53a3f3087be361dacfc02e7a85b6d6142a41ce8a    ~2.6.23-rc              14 Sept                 "WORKS!"
> GOOD    -   ea3c4b126ad63bd782c7bb5266bb4fd88e203169    ~2.6.23-rc               4 Sept                 "WORKS!"
> 
> 
