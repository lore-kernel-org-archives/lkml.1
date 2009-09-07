Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbZIGS2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbZIGS2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752459AbZIGS2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:28:09 -0400
Received: from mail-yw0-f175.google.com ([209.85.211.175]:50973 "EHLO
	mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbZIGS2I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vjXXJMpY7DYcGb4oowmgSY6+bKBfMm2b8oXi8w/QWS+EK4a/8Re99/C5Xy/JC0214r
         q1P3jjxPCvNn16PjDFROluRT0ETnqthRKEDsm0nObSDRhz0RiFZ6xT//lGyPxZr9fXMb
         kO0W7kX+KZXCACC5dMq1zg6mi0iaM3ZCYTqo0=
MIME-Version: 1.0
In-Reply-To: <20090907102613.GA25295@linux-mips.org>
References: <197625223d8cb6ec3fc3e7da4501dd65@localhost>
	 <20090907102613.GA25295@linux-mips.org>
Date: Mon, 7 Sep 2009 11:28:05 -0700
Message-ID: <347733d50909071128v63b2d8a1hd6a87a361c14017e@mail.gmail.com>
Subject: Re: [PATCH] MIPS: Machine check exception in kmap_coherent()
From: Kevin Cernekee <cernekee@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 7, 2009 at 3:26 AM, Ralf Baechle<ralf@linux-mips.org> wrote:
> Too complicated.  The fault is happening because the non-SMTC code is trying
> to be terribly clever and pre-loading the TLB with a new wired entry.  On
> SMTC where multiple processors are sharing a single TLB are more careful
> approach is needed so the code does a TLB probe and carefully and re-uses
> an existing entry, if any.  Which happens to be just what we need.
>
> So how about below - only compile tested - patch?

That is an interesting idea.  However, I am not sure we want the IPI
ISR to overwrite copy_user_highpage()'s TLB entry.  That means that
when the interrupt returns, our coherent mapping will likely point to
a different page.  It will avoid the machine check exception, but it
will potentially cause silent, intermittent data corruption instead.

Taking another cue from the SMTC implementation, though - my v2 patch
adds an extra set of fixmap addresses for the in_interrupt() case,
avoiding the VA conflict entirely.  What do you think?

I tested this scheme on non-SMTC.  I suspect that the same change is
required for MT + MP cores like the 1004K, but probably not MT only
cores like 34K which don't use cacheop IPIs.
