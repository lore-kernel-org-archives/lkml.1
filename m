Return-Path: <linux-kernel-owner+w=401wt.eu-S1756134AbYARI2F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134AbYARI2F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 03:28:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753910AbYARI1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 03:27:54 -0500
Received: from smtp.ustc.edu.cn ([202.38.64.16]:41307 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751707AbYARI1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 03:27:53 -0500
Message-ID: <400644884.18765@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 18 Jan 2008 16:27:52 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Michael Rubin <mrubin@google.com>
Cc: Andrew Morton <akpm@osdl.org>, Peter Zijlstra <peterz@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/13] writeback bug fixes and simplifications take 2
References: <400401292.24795@ustc.edu.cn> <532480950801172351p7603e8d0icdc8e2b27c1e0051@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532480950801172351p7603e8d0icdc8e2b27c1e0051@mail.gmail.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.12-2006-07-14
Message-Id: <E1JFmZs-0000wa-3r@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 11:51:51PM -0800, Michael Rubin wrote:
> On Jan 15, 2008 4:36 AM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> > Andrew,
> >
> > This patchset mainly polishes the writeback queuing policies.
> > The main goals are:
> >
> > (1) small files should not be starved by big dirty files
> > (2) sync as fast as possible for not-blocked inodes/pages
> >     - don't leave them out; no congestion_wait() in between them
> > (3) avoid busy iowait for blocked inodes
> >     - retry them in the next go of s_io(maybe at the next wakeup of pdflush)
> >
> > The role of the queues:
> >
> > s_dirty:   park for dirtied_when expiration
> > s_io:      park for io submission
> > s_more_io: for big dirty inodes, they will be retried in this run of pdflush
> >            (it ensures fairness between small/large files)
> > s_more_io_wait: for blocked inodes, they will be picked up in next run of s_io
> 
> Quick question to make sure I get this. Each queue is sorted as such:
> 
> s_dirty - sorted by the dirtied_when field
> s_io - sorted by  no explicit key but by the order we want to process
> in sync_sb_inodes
> s_more_io - held for later they are sorted in the same manner as s_io
> 
> Is that it?

Yes, exactly. s_io and s_more_io can be considered as one list broken
up into two - to provide the cursor for sequential iteration.
And s_more_io_wait is simply a container for blocked inodes.

