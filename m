Return-Path: <linux-kernel-owner+w=401wt.eu-S1756859AbXI0OAh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbXI0OAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 10:00:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755746AbXI0OAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 10:00:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:35711 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755628AbXI0OA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 10:00:29 -0400
Date: Thu, 27 Sep 2007 15:00:07 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: lockdep wierdness...
Message-ID: <20070927140007.GA17543@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Trond Myklebust <Trond.Myklebust@netapp.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <1190671658.6700.31.camel@heimdal.trondhjem.org> <20070925021359.GB11809@goodmis.org> <1190901067.31636.6.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190901067.31636.6.camel@twins>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2007 at 03:51:07PM +0200, Peter Zijlstra wrote:
> Christoph,
> 
> does Steve's story make sense? 

Yes.

> All that would need to be done is add an extra lock_class_key to
> file_system_type for i_mutex_dir_key, and extend alloc_inode to say
> something like:
> 
>   if (dir)
>     lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_dir_key);
>   else
>     lockdep_set_class(&inode->i_mutex, &sb->s_type->i_mutex_key);

Unfortunately we don't know what type of inode we have when calling
alloc_inode.  We only know it after reading in the inode from disk,
aka in unlock_new_inode.  Then again there is no reason to use
i_mutex before unlock_new_inode returns, so maybe we could defer
initializing it until unlock_new_inode.  I'm pretty sure we'll have
to fix a few filesystems that take i_mutex before that despite not
needing it, e.g. through i_size_write, though.
