Return-Path: <linux-kernel-owner+w=401wt.eu-S932416AbYBHCsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416AbYBHCsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 21:48:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757097AbYBHCsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 21:48:07 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43437 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756154AbYBHCsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:48:05 -0500
Date: Thu, 7 Feb 2008 18:48:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, nfsv4@linux-nfs.org
Subject: Re: [GIT] Please pull 2 NFS client fixes
Message-Id: <20080207184818.e40d5277.akpm@linux-foundation.org>
In-Reply-To: <1202432841.18376.50.camel@heimdal.trondhjem.org>
References: <1202432841.18376.50.camel@heimdal.trondhjem.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Feb 2008 20:07:21 -0500 Trond Myklebust <Trond.Myklebust@netapp.com> wrote:

> commit 5d47a35600270e7115061cb1320ee60ae9bcb6b8
> Author: Trond Myklebust <Trond.Myklebust@netapp.com>
> Date:   Thu Feb 7 17:24:07 2008 -0500
> 
>     NFS: Fix a potential file corruption issue when writing
>     
>     If the inode is flagged as having an invalid mapping, then we can't rely on
>     the PageUptodate() flag. Ensure that we don't use the "anti-fragmentation"
>     write optimisation in nfs_updatepage(), since that will cause NFS to write
>     out areas of the page that are no longer guaranteed to be up to date.
>     
>     A potential corruption could occur in the following scenario:
>     
>     client 1			client 2
>     ===============			===============
>     				fd=open("f",O_CREAT|O_WRONLY,0644);
>     				write(fd,"fubar\n",6);	// cache last page
>     				close(fd);
>     fd=open("f",O_WRONLY|O_APPEND);
>     write(fd,"foo\n",4);
>     close(fd);
>     
>     				fd=open("f",O_WRONLY|O_APPEND);
>     				write(fd,"bar\n",4);
>     				close(fd);
>     -----
>     The bug may lead to the file "f" reading 'fubar\n\0\0\0\nbar\n' because
>     client 2 does not update the cached page after re-opening the file for
>     write. Instead it keeps it marked as PageUptodate() until someone calls
>     invaldate_inode_pages2() (typically by calling read()).

Is this one worth feeding back into 2.6.24.x?  (for various values of "4"?)
