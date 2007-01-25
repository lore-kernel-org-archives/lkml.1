Return-Path: <linux-kernel-owner+w=401wt.eu-S932874AbXAYAFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874AbXAYAFh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 19:05:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752098AbXAYAFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 19:05:37 -0500
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:41225 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752097AbXAYAFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 19:05:36 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=UVpSNIVgtmAYt2nckF3fCq3Kbthu8KPVUW+ckBSx3JCoZyzQ1ubPTef2D4t4GRhBtyqs4nJT7k9ni3Uj/xMYZ6YZRUMBSaXUX6eciEdscS4UazEesF3UW0/cYbwNxjz3R5211NgUwbaWPyTMcaQRSTeBKwJSEa0raHqdgGiO/7U=  ;
X-YMail-OSG: Yygb12QVM1lgq7WFrc.EDwmOqtIELHor_sHnjJ3JNXS1VLAGmYzNeDWqIgo.Pv6aCZZSWh_Yj_8x.GjBsILBuaoba5wHPWPh3TbYrLIQ7UU2GnokD24-
Message-ID: <45B7F43B.9060905@yahoo.com.au>
Date: Thu, 25 Jan 2007 11:05:15 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@osdl.org
Subject: Re: [PATCH 1/2]: Fix BUG in cancel_dirty_pages on XFS
References: <20070123223702.GF33919298@melbourne.sgi.com>	 <1169640835.6189.14.camel@twins>  <45B7627B.8050202@yahoo.com.au> <1169649604.6189.27.camel@twins>
In-Reply-To: <1169649604.6189.27.camel@twins>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2007-01-25 at 00:43 +1100, Nick Piggin wrote:
> 
> 
>>>Have you seen the new launder_page() a_op? called from
>>>invalidate_inode_pages2_range()
>>
>>It would have been nice to make that one into a more potentially
>>useful generic callback.
> 
> 
> That can still be done when the need arises, right?

Yeah I guess so.

>>But why was it introduced, exactly? I can't tell from the code or
>>the discussion why NFS couldn't start the IO, and signal the caller
>>to wait_on_page_writeback and retry? That seemed to me like the
>>convetional fix.
> 
> 
> to quote a bit:
> 
> On Tue, 19 Dec 2006 18:19:38 -0500
> Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> 
> 
>>    NFS: Fix race in nfs_release_page()
>>    
>>    invalidate_inode_pages2() may set the dirty bit on a page owing to the call
>>    to unmap_mapping_range() after the page was locked. In order to fix this,
>>    NFS has hooked the releasepage() method. This, however leads to deadlocks
>>    in other parts of the VM.
> 
> 
> and:
> 
> 
>>>Now, arguably the VM shouldn't be calling try_to_release_page() with
>>>__GFP_FS when it's holding a lock on a page.
>>>
>>>But otoh, NFS should never be running lock_page() within nfs_release_page()
>>>against the page which was passed into nfs_release_page().  It'll deadlock
>>>for sure.
>>
>>The reason why it is happening is that the last dirty page from that
>>inode gets cleaned, resulting in a call to dput().

OK but what's the problem with just failing to release the page if it
is dirty, I wonder? In the worst case, page reclaim will just end up
doing a writeout to clean it.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
