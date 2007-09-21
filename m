Return-Path: <linux-kernel-owner+w=401wt.eu-S1758264AbXIUMrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264AbXIUMrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 08:47:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbXIUMrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 08:47:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:64505 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381AbXIUMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 08:47:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZZINsEpFrC6J46tVQzelYCGRnv5CxS9wUw/t+QvM+C0r0nuZQMScw6SMHuzeAw6mWgnS55Ddp/EFDGWypAUGInZQgV0m5p+2pWLnGBe05sfiYeqBI6VUmXED/yHdr173B9lGFG+5cfnfuSgFgGI6OJj0IvyGEff9nTKdKzHKS2U=
Message-ID: <3402120c0709210547mb66162fv759a8f088beb0437@mail.gmail.com>
Date: Fri, 21 Sep 2007 14:47:04 +0200
From: "Arvin Moezzi" <moezzia@gmail.com>
To: "James Pearson" <james-p@moving-picture.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
Cc: aarapov@redhat.com, akpm@linux-foundation.org, hpa@zytor.com
In-Reply-To: <46F39319.9090705@moving-picture.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1IXziD-0003YJ-0w@moving-picture.com>
	 <3402120c0709201856j58c3775bq8dc7886785a11344@mail.gmail.com>
	 <46F39319.9090705@moving-picture.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+
> >>+               if (copy_to_user(buf, page, retval)) {
> >
> >                                                                 ^^^^
> > shouldn't you only copy min(count,retval) bytes? otherwise you could
> > write beyond the users buffer "buf", right?
>
> AFAIK, 'retval' can never be greater than 'this_len', which can never be
> greater than 'max_len', which can never be greater than 'count'

I think that's not true. 'count' is changing through the iteration.
The difference in the mem_read():

* while (count > 0) {
*     int this_len, retval;
*
*      this_len = (count > PAGE_SIZE) ? PAGE_SIZE : count;
*      retval = access_process_vm(task, src, page, this_len, 0);
*
*      ...
* }

is the fact, that this_len = min(PAGE_SIZE, count) is in the
iteration block, hence retval <= this_len <= count in each iteration
step. So this is ok. But IMHO in your code 'retval' may be bigger than
'count' in the last iteration of the block, because 'max_len' is fix
through your iteration but 'count' is changing. Or am i missing
something?

> James Pearson

Arvin
