Return-Path: <linux-kernel-owner+w=401wt.eu-S1161624AbXD3A1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161624AbXD3A1J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 20:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161625AbXD3A1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 20:27:09 -0400
Received: from smtp-out.google.com ([216.239.45.13]:61400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161624AbXD3A1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 20:27:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=D1yMR7RHiOGyV4r45MLuR2U/qTS4WGky0R1b8Biv6XsmNgfpPc8hdB8Pk0QgIYjtU
	GDiuLzRE4LwnlxcGc5uIA==
Message-ID: <463537C2.5050804@google.com>
Date: Sun, 29 Apr 2007 17:26:42 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Trond Myklebust <trond.myklebust@fys.uio.no>
CC: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: NR_UNSTABLE_FS vs. NR_FILE_DIRTY: double counting pages?
References: <4632A1A6.90702@google.com> <1177878135.6400.37.camel@heimdal.trondhjem.org>
In-Reply-To: <1177878135.6400.37.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> On Fri, 2007-04-27 at 18:21 -0700, Ethan Solomita wrote:
>> There are several places where we add together NR_UNSTABLE_FS and
>> NF_FILE_DIRTY:
>>
>> sync_inodes_sb()
>> balance_dirty_pages()
>> wakeup_pdflush()
>> wb_kupdate()
>> prefetch_suitable()
>>
>>     I can trace a standard codepath where it seems both of these are set
>> on the same page:
>>
>> nfs_file_aops.commit_write ->
>>     nfs_commit_write
>>     nfs_updatepages
>>     nfs_writepage_setup
>>     nfs_wb_page
>>     nfs_wb_page_priority
>>     nfs_writepage_locked
>>     nfs_flush_mapping
>>     nfs_flush_list
>>     nfs_flush_multi
>>     nfs_write_partial_ops.rpc_call_done
>>     nfs_writeback_done_partial
>>     nfs_writepage_release
>>     nfs_reschedule_unstable_write
>>     nfs_mark_request_commit
>>     incr NR_UNSTABLE_NFS
>>
>> nfs_file_aops.commit_write ->
>>     nfs_commit_write
>>     nfs_updatepage
>>     __set_page_dirty_nobuffers
>>     incr NF_FILE_DIRTY
>>
>>
>>     This is the standard code path that derives from sys_write(). Can
>> someone either show how this code sequence can't happen, or confirm for
>> me that there's a bug?
>>     -- Ethan
> 
> It should not happen. If the page is on the unstable list, then it will
> be committed before nfs_updatepage is allowed to redirty it. See the
> recent fixes in 2.6.21-rc7.

	Above I present a codepath called straight from sys_write() which seems 
to do what I say. I could be wrong, but can you address the code paths I 
show above which seem to set both?
	-- Ethan
