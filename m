Return-Path: <linux-kernel-owner+w=401wt.eu-S932817AbZDAW1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932817AbZDAW1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 18:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753253AbZDAW1W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 18:27:22 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:58085 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbZDAW1V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 18:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=CJz+cUPRUmRRvhdIHrd7TqVW2a6P5EAXjMg2aNM0OSkPPMCe8KvAflsumCLpx4g8sj
         illZDFHBQj4WAnmwgmdX4lnxWBfSLKj901/RZQBYcSqBF6cCoFBCFXbq8NuEOr/u+Dyz
         Q/Fjh1iPN5mlD6aCQDK1A9C3uOkN6+JOtF+ug=
Subject: Re: [PATCH 1/2] lib: add fast lzo decompressor
From: Andreas Robinson <andr345@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alain Knaff <alain@knaff.lu>, linux-kernel@vger.kernel.org
In-Reply-To: <49D3D4C0.1080506@zytor.com>
References: <1238593252-3435-1-git-send-email-andr345@gmail.com>
	 <1238593252-3435-2-git-send-email-andr345@gmail.com>
	 <49D3927A.2050406@zytor.com> <1238613730.10514.35.camel@andreas-desktop>
	 <49D3D4C0.1080506@zytor.com>
Content-Type: text/plain
Date: Thu, 02 Apr 2009 00:27:07 +0200
Message-Id: <1238624827.15230.58.camel@andreas-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-01 at 13:55 -0700, H. Peter Anvin wrote:
> Andreas Robinson wrote:
> > 
> > Perhaps the system can default to the safe decompressor for normal use
> > and choose the fast one if STATIC is defined or when system_state ==
> > SYSTEM_BOOTING?
> > 
> 
> Do we really need two pieces of code?

To get the higher speed offered by the fast function, yes.

Merging the two with some macro magic and then compile twice with
different macro definitions could work though. That might hurt the
readability of the code a bit. Or help. :-) I'll look into it.

Anyway, I assume it is maintainability rather than size you're concerned
about here?

The duplicate function adds just 1.7 KB to the kernel and you throw it
out once the kernel has finished booting.

OTOH, the safe version is far from useless. 

I estimate (but haven't tested yet) that you would lose about 40 ms in
the Eee test case. That is, the boot-time savings are reduced from 123
to perhaps 85 ms which is still acceptable. It is certainly much less
complicated than the alternatives, so if that's what you would prefer I
can go that way.

>   What if we have memory corruption 
> during early boot - it seems we'd want to at least try to catch that 
> with an error message rather than just crashing.

This is very easy to do, so consider it done.

The decompressor is essentially a glorified memcpy that can copy the
same data to several locations. You only have to check whether the write
pointer has passed the end of the output buffer to see if something went
wrong.


