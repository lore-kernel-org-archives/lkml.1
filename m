Return-Path: <linux-kernel-owner+w=401wt.eu-S1760510AbXEQGkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760510AbXEQGkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 02:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761192AbXEQGj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 02:39:57 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:30921 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754538AbXEQGj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 02:39:56 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=KJU2JfFC8hoMEJ8O0VCB9IsXesrTydZeLOdcbOH4W0ZkZZdCmFbQmyReegCR1qc8MTqWTNmI1jpQ36PT3ArDRNrCLyKnkl6qi4W0ZARm6VnYYYG6/i+EpfhtG7fGSWgWA3mJXmfM8gwKjALhHL0gWn4AslCRNAfghv8rD/xfzKY=  ;
X-YMail-OSG: PNQhCOQVM1kvY4_Hn_CE9W2lFA8eseO8QEGzP1x0R23r5eBbAvSfXu2lM1FsGlgxGW87ojDL8Q--
Message-ID: <464BF8B2.3080101@yahoo.com.au>
Date: Thu, 17 May 2007 16:39:46 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
References: <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com> <31162.1179341123@redhat.com>
In-Reply-To: <31162.1179341123@redhat.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> 
> 
>>You can drop the lock, do the invalidation,
> 
> 
> Hmmm...  There's a danger of incurring a race by doing that.  Consider two
> processes both trying to write to a dirty page for which writeback will be
> rejected:
> 
>  (1) The first process gets EKEYREJECTED from the server, drops its lock and
>      is then preempted.
> 
>  (2) The second process gets EKEYREJECTED from the server, drops its lock,
>      truncates the page, reloads the page and modifies it.
> 
>  (3) The first process resumes and truncates the page, thereby splatting the
>      second process's write.
> 
> Or:
> 
>  (1) The first process gets EKEYREJECTED from the server, clears the writeback
>      information from the page, drops its lock and is then preempted.
> 
>  (2) The second process attaches its own writeback information to the page and
>      modifies it.
> 
>  (3) The first process resumes and truncates the page, thereby splatting the
>      second process's write.

If there are race issues involving concurrent invalidations, then you'd
fix that up by taking a filesystem specific lock to prevent them.

Generic write path should be holding i_mutex, but I don't think you can
take that from page_mkwrite... Just add one of your own.


> Really, what I want to do is pass the page lock to truncate to deal with.
> Better still, I want truncate to be selective, based on whether or not a page
> is still associated with the rejected writeback.  I wonder if I should call
> truncate_complete_page() or invalidate_complete_page() directly.

No, you shouldn't. We could theoretically introduce a new API for this,
but I think it would be preferable if you can fix the race in the fs.

-- 
SUSE Labs, Novell Inc.
