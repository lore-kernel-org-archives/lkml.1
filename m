Return-Path: <linux-kernel-owner+w=401wt.eu-S1762651AbXFARQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762651AbXFARQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:16:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760958AbXFARQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:16:21 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:60869 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760692AbXFARQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:16:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=upB0W0ElpgbOOvxp5Hr638bqE/Qk2ORmSSxK1GTw0FNm3ZlPBjG8nX3a2MYN3sThGfu6w+rCne+sWKFXScTvWKa8gB2IuOLEvxqSRb+o/aodgHG3bsOjFujRpMyai6zS3n/Wr24Tw0fEcD0la7zU6qKSkaqzLoVNUckuAZgBpWQ=
Date: Fri, 1 Jun 2007 21:15:11 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>,
       Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Fix possible leakage of blocks in UDF
Message-ID: <20070601171511.GB8398@cvg>
References: <20070524165935.GB19709@duck.suse.cz> <20070524170554.GC19709@duck.suse.cz> <20070524203653.GA7693@duck.suse.cz> <465DF0B4.2050203@sandeen.net> <465DF91F.3010201@sandeen.net> <20070531174201.GB8392@cvg> <465F09E7.7000300@sandeen.net> <20070601164926.GA8398@cvg> <20070601100425.89537dda.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070601100425.89537dda.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Andrew Morton - Fri, Jun 01, 2007 at 10:04:25AM -0700]
| On Fri, 1 Jun 2007 20:49:26 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| 
| > [Eric Sandeen - Thu, May 31, 2007 at 12:46:15PM -0500]
| > | Cyrill Gorcunov wrote:
| > | 
| > | >Eric, could you please try the following:
| > | >
| > | >1) declare the spinlock in the top of inode.c as
| > | >
| > | >	DEFINE_SPINLOCK(udf_drop_lock);
| > | >
| > | >2) replace in udf_drop_inode()
| > | >
| > | >	kernel_lock -> spin_lock(&udf_drop_lock);
| > | >	kernel_unlock -> spin_unlock(&udf_drop_lock);
| > | >
| > | >I'm not sure if it help but you may try ;)
| > | >
| > | >		Cyrill
| > | >
| > | 
| > | I'm sure it'll avoid the deadlock but....
| > | 
| > | Any sense of what the BKL is actually trying to protect in this case?
| > | 
| > | Is it really only trying to prevent concurrent prealloc-discarders, or 
| > | is there more?
| > | 
| > | -Eric
| > | 
| > 
| > Hi Eric,
| > it seems BKL only trying to protect from concurrent discard_prealloc.
| > Moreover, a lot of UDF code does call iput with BKL held, so the only
| > solution I see is to add spinlocks to udf_drop_inode... I'm making patch
| > soon. Any comments?
| > 
| 
| Recursive lock_kernel() is OK.
| 
| spin_lock() insode lock_kernel() is OK.
| 
| lock_kernel() inside spin_lock() is not OK, but if this was happening you'd
| only rarely hit a deadlock and I think this locks up every time.
| 
| We don't know what's causing this hang, do we?
| 

Actually I've read in Robert Love book that recursive kernel_lock is
supposed but as Eric wrote "he's sure spin_lock will avoid deadlock"...
So I'm investigating this (unfortunelly can't test it myself - have
UDF compiled into kernel :(.

		Cyrill

