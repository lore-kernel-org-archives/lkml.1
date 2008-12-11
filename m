Return-Path: <linux-kernel-owner+w=401wt.eu-S1757160AbYLKRgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160AbYLKRgy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 12:36:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbYLKRgp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 12:36:45 -0500
Received: from rcsinet14.oracle.com ([148.87.113.126]:60126 "EHLO
	rgminet14.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756659AbYLKRgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 12:36:44 -0500
Date: Thu, 11 Dec 2008 09:34:37 -0800
From: Joel Becker <Joel.Becker@oracle.com>
To: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
Subject: Re: configfs, dlm_controld & lockdep
Message-ID: <20081211173437.GA25844@ca-server1.us.oracle.com>
Mail-Followup-To: Steven Whitehouse <swhiteho@redhat.com>,
	linux-kernel@vger.kernel.org, cluster-devel@redhat.com
References: <1229005208.3625.26.camel@localhost.localdomain> <20081211144441.GA19128@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211144441.GA19128@hawkmoon.kerlabs.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.16 (2007-06-11)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.49414F39.01C6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 11, 2008 at 03:44:41PM +0100, Louis Rilling wrote:
> These warnings are known issues. This results from a lack of lockdep annotations
> in configfs. I must admit that I started to send patches for that a few months
> ago, and then could not find time to finish this work.
> 
> The problem is a bit harder than just playing with I_MUTEX_CHILD, I_MUTEX_PARENT
> and I_MUTEX_NORMAL, since configfs recursively locks variable numbers
> (this can go to as many as the depth of the whole configfs tree) of
> config_group inodes during operations like mkdir(), rmdir(), and depend_item().
> 
> I was working on two kinds of solutions:
> 1) insert lockdep_off()/lockdep_on() at the places of recursion,
> 2) separate default groups inode mutex classes according to their depth under
> the created group they belong to.
> 
> People tend to reject any proposition like 1), but IIRC Joel was tending to
> accept it.
> 
> Solution 2) does not work for depend_item(). This needs to rework the locking
> scheme of depend_item() by removing the variable lock recursion depth, and I
> think that it's doable thanks to the configfs_dirent_lock.
> 	Joel, what do you think about this?

	I've been waiting for your patch for (1).  I am wary of the (2)
approach.  Not because it wouldn't work for mkdir(2) - I think it would.
But rmdir(2) has the same recursive locking, with far more importance
(live objects), and would print the same error.

Joel

-- 

Life's Little Instruction Book #267

	"Lie on your back and look at the stars."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
