Return-Path: <linux-kernel-owner+w=401wt.eu-S1030801AbXD1BVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030801AbXD1BVy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 21:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030810AbXD1BVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 21:21:54 -0400
Received: from smtp-out.google.com ([216.239.45.13]:63035 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030801AbXD1BVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 21:21:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:
	subject:content-type:content-transfer-encoding;
	b=aBypu/5cG+P344HZFl2ivWS4y11XI0mqnkmRAjOFZSqBjNWR854NsD+46X90cWc3H
	XPtzkQqsABk/KzD+iWHSg==
Message-ID: <4632A1A6.90702@google.com>
Date: Fri, 27 Apr 2007 18:21:42 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: NR_UNSTABLE_FS vs. NR_FILE_DIRTY: double counting pages?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

    There are several places where we add together NR_UNSTABLE_FS and
NF_FILE_DIRTY:

sync_inodes_sb()
balance_dirty_pages()
wakeup_pdflush()
wb_kupdate()
prefetch_suitable()

    I can trace a standard codepath where it seems both of these are set
on the same page:

nfs_file_aops.commit_write ->
    nfs_commit_write
    nfs_updatepages
    nfs_writepage_setup
    nfs_wb_page
    nfs_wb_page_priority
    nfs_writepage_locked
    nfs_flush_mapping
    nfs_flush_list
    nfs_flush_multi
    nfs_write_partial_ops.rpc_call_done
    nfs_writeback_done_partial
    nfs_writepage_release
    nfs_reschedule_unstable_write
    nfs_mark_request_commit
    incr NR_UNSTABLE_NFS

nfs_file_aops.commit_write ->
    nfs_commit_write
    nfs_updatepage
    __set_page_dirty_nobuffers
    incr NF_FILE_DIRTY


    This is the standard code path that derives from sys_write(). Can
someone either show how this code sequence can't happen, or confirm for
me that there's a bug?
    -- Ethan

