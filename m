Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbZBLD2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbZBLD2e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 22:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755515AbZBLD2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 22:28:24 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:54136 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209AbZBLD2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 22:28:23 -0500
Date: Thu, 12 Feb 2009 03:28:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Description of open_to_namei_flags()?
Message-ID: <20090212032821.GD28946@ZenIV.linux.org.uk>
References: <200902120310.n1C3AwHL076677@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902120310.n1C3AwHL076677@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:10:58PM +0900, Tetsuo Handa wrote:
> > static inline int open_to_namei_flags(int flag)
> > {
> > 	if ((flag+1) & O_ACCMODE)
> > 		flag++;
> > 	return flag;
> > }
> 
> I noticed that open_to_namei_flags() can't yield
> "00 - no permissions needed" output for "11 - special" input.
> To yield "00 - no permissions needed" output for "11 - special" input,
> I think
> 
>   static inline int open_to_namei_flags(int flag)
>   {
>   	return (flag + 1) & O_ACCMODE;
>   }
> 
> is needed.

No.  Comments are rather misleading; the code is correct.

> sys_open(path, 0) is open for reading.
> sys_open(path, 1) is open for writing.
> sys_open(path, 2) is open for reading and writing.
> What is sys_open(path, 3) for?

open for ioctls only; checks for rw permissions, doesn't allow read or
write calls.  Note that the latter is controlled by ->f_mode, which does
*not* come from open_to_namei_flags() (and is calculated as you suggested).
Results of open_to_namei_flags() are used for permission checks, where
3 -> read|write is correct.
