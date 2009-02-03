Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZBCBY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZBCBY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbZBCBYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:24:48 -0500
Received: from smtp112.mail.mud.yahoo.com ([209.191.84.65]:34267 "HELO
	smtp112.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751901AbZBCBYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:24:47 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3pN6vSIE1wL181u+y9NGPZ/g+EKC1WxrhJzGQeVHRWjx4P55kHgoJQttexOi9784WU3cqK4Tvha3NB3g851fUoAdkxpb+qmrM1oUl3XJYUTyk6FZ6UU3vh3Y6KtHHDNAZogFys81K6ENqfrAQX2l4KyoH5qk0vmw+WqdkdEWFLM=  ;
X-YMail-OSG: Agq4IdkVM1nTdhe42xQ69cAstetHQb6IJQayS0ZjnLmRz_21eqZJpBul5ISVOj4H1mowtZm1zbC7fhnwcrzOy3Cl7oUIfhsvcbAkZOmjI1nBmeK7Zc_H8ryYIfD9eHwc_g.ATnsScdYl_dwpGWtNR7DqkoXW6ZRCiyjdMLAaAlgF0Fbd2XcC0FPAlQ3d5A--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: Commit 31a12666d8f0c22235297e1c1575f82061480029 slows down Berkeley DB
Date: Tue, 3 Feb 2009 12:24:20 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, npiggin@suse.de
References: <20090130012315.GB19554@duck.suse.cz>
In-Reply-To: <20090130012315.GB19554@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902031224.20856.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 30 January 2009 12:23:15 Jan Kara wrote:
>   Hi,
>
>   today I found that commit 31a12666d8f0c22235297e1c1575f82061480029 (mm:
> write_cache_pages cyclic fix) slows down operations over Berkeley DB.
> Without this "fix", I can add 100k entries in about 5 minutes 30s, with
> that change it takes about 20 minutes.
>   What is IMO happening is that previously we scanned to the end of file,
> we left writeback_index at the end of file and went to write next file.
> With the fix, we wrap around (seek) and after writing some more we go
> to next file (seek again).

Hmm, but isn't that what pdflush has asked for? It is wanting to flush
some of the dirty data out of this file, and hence it wants to start
from where it last flushed out and then cycle back and flush more?


>   Anyway, I think the original semantics of "cyclic" makes more sence, just
> the name was chosen poorly. What we should do is really scan to the end of
> file, reset index to start from the beginning next time and go for the next
> file.

Well, if we think of a file as containing a set of dirty pages (as it
appears to the high level mm), rather than a sequence, then behaviour
of my patch is correct (ie. there should be no distinction between dirty
pages at different offsets in the file).

However, clearly there is some problem with that assumption if you're
seeing a 4x slowdown :P I'd really like to know how it messes up the IO
patterns. How many files in the BDB workload? Are filesystem blocks
being allocated at the end of the file while writeout is happening?
Delayed allocation?


>   I can write a patch to introduce this semantics but I'd like to hear
> opinions of other people before I do so.

I like dirty page cleaning to be offset agnostic as far as possible,
but I can't argue with numbers like that. Though maybe it would be
possible to solve it some other way.

