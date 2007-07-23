Return-Path: <linux-kernel-owner+w=401wt.eu-S932882AbXGWAqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932882AbXGWAqB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933583AbXGWAp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:45:27 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:46305 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933536AbXGWApZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:45:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=NebwoYh/TpLoxacmKrkH1wXv8MX45BXHmcMo/P5HGWNDJZZDu5TyFSF8wIOXnVbypjiWf2QGZ2sovVLJFsSkpOBwQ6TqcEN+c2/rGwefOCvNo7CD6y1sZg0tKimLJzc/OOChDHyckLnW4Lv+bssUPyAUMSInPXsT593daDnRtR0=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: Problematic __attribute__((section(" "))) and gcc alignment
Date: Mon, 23 Jul 2007 01:45:18 +0100
User-Agent: KMail/1.8.2
Cc: linux-kernel@vger.kernel.org
References: <20070621203236.GA6463@Krystal>
In-Reply-To: <20070621203236.GA6463@Krystal>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707230145.18165.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 June 2007 21:32, Mathieu Desnoyers wrote:
> Let's take arch/i386/boot/video.h as an example:
> 
> it defines 
> 
> struct card_info {
>         const char *card_name;
>         int (*set_mode)(struct mode_info *mode);
>         int (*probe)(void);
>         struct mode_info *modes;
>         int nmodes;             /* Number of probed modes so far */
>         int unsafe;             /* Probing is unsafe, only do after "scan" */
>         u16 xmode_first;        /* Unprobed modes to try to call anyway */
>         u16 xmode_n;            /* Size of unprobed mode range */
> };
> 
> Which is 28 bytes in size (so it is ok for now). If one single field is
> added, gcc will start aligning this structure on 32 bytes boundaries.
> (see http://gcc.gnu.org/ml/gcc-bugs/1999-11/msg00914.html)
> 
> We then have
> #define __videocard struct card_info __attribute__((section(".videocards")))
> extern struct card_info video_cards[], video_cards_end[];
> 
> Which instructs gcc to put these structures in the .videocards section.
> The linker scripts arch/i386/boot/setup.ld will assign video_cards and
> video_cards_end as pointers to the beginning and the end of this
> section. video_cards[0] is therefore expected to give the first
> structure in the section.
> 
> The problem with this is that gcc will align it on 32 bytes boundaries
> relative to what it "thinks" is the start of the section, which has
> nothing to do with the actual section layout given by the linker script.

The problem is that gcc is too eager to align stuff to some big power of two
upon reaching some irrelevant threshold. Why structures 32 bytes and more
in size should be aligned to 32 bytes (even if they have no doubles
and thus are not planned to be used by SSE code) is beyond me.
Why string literals of 32+ bytes are aligned is (beyond me)^2.

These are reverted in latest gcc (for -Os only):

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=31319

but meanwhile gcc started to align stack to 16 bytes, *unconditionally*:

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=32849

I imagine 4K stack people will especially like it.

Apart from being bloaty, this also broke de-facto i386 ABI.
There is a solution which isnt bloaty and doesn't break the ABI.
But it wasn't chosen. :(
--
vda
