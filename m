Return-Path: <linux-kernel-owner+w=401wt.eu-S1760475AbYCURPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760475AbYCURPa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758840AbYCURPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:15:19 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:29073 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758827AbYCURPR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:15:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NApFUbBUhabkIC+VTq4pWRfik10m+pxhAOW2gzYQLHrz2uSM9VQJvhQV/KZVZ4P+Al67Sv+DMM6A6HUBJuYG3D5PsfabPLLwX1UI1+AjSP0/vK8ueI16msUIjqpri6uDTixFnTM5HVpoujnS33Ssp0sZ4do+nih44hZdvjJXWh0=
Message-ID: <a36005b50803211015l64005f6emb80dbfc21dcfad9f@mail.gmail.com>
Date: Fri, 21 Mar 2008 10:15:15 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH prototype] [0/8] Predictive bitmaps for ELF executables
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20080320090005.GA25734@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080318209.039112899@firstfloor.org>
	 <20080318003620.d84efb95.akpm@linux-foundation.org>
	 <20080318141828.GD11966@one.firstfloor.org>
	 <20080318095715.27120788.akpm@linux-foundation.org>
	 <20080318172045.GI11966@one.firstfloor.org>
	 <20080318104437.966c10ec.akpm@linux-foundation.org>
	 <20080319083228.GM11966@one.firstfloor.org>
	 <20080319020440.80379d50.akpm@linux-foundation.org>
	 <a36005b50803191545h33d1a443y57d09176f8324186@mail.gmail.com>
	 <20080320090005.GA25734@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2008 at 2:00 AM, Andi Kleen <andi@firstfloor.org> wrote:
>  What chaos exactly? For me it looks rather that a separatate database
>  would be a recipe for chaos. e.g. for example how would you make sure
>  the database keeps track of changing executables?

I didn't say that a separate file with the data is better.  In fact, I
agree, it's not much better.  What I referred to as the problem is
that this is an extension which is not part of the ELF spec and
doesn't fit in.  The ELF spec has rules how programs have to deal with
unknown parts of a binary.  Only this way programs like strip can work
in the presence of extensions.  There are ways to embed such a bitmap
but not ad-hoc as you proposed.


>  But if the binutils leanred about this and added a bitmap phdr (it
>  tends to be only a few hundred bytes even on very large executables)
>  one seek could be avoided.

And that is only one advantage.  Let's not go done the path of invalid
ELF files.


>  > Furthermore, by adding all this data to the end of the file you'll
>
>  We are talking about 32bytes for each MB worth of executable.
>  You can hardly call that "all that data".

This wasn't a comment about the size of the data but the type of data.
 The end of a binary contains data which is not used at runtime.  Now
you're mixing in data which is used.


>  > pages will be needed.  Far more than in most cases.  The prefetching
>  > should really only cover the commonly used code paths in the program.
>
>  Sorry that doesnt make sense. Anything that is read at startup
>  has to be prefetched, even if that code is only executed once.
>  Otherwise the whole scheme is rather useless.
>  Because even a single access requires the IO to read it from
>  disk.

Again, you misunderstand.  I'm not proposing to exclude pages which
are only used at startup time.  I mean the data collection should stop
some time after a process was started to account for possibly quite
different code paths which are taken by different runs of the program.
 I.e., don't record page faults for the entire runtime of the program
which, hopefully in most cases, will result in all the pages of a
program to be marked (unless you have a lot of dead code in the binary
and it's all located together).
