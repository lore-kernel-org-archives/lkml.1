Return-Path: <linux-kernel-owner+w=401wt.eu-S1757747AbZCARA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757747AbZCARA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 12:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZCARAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 12:00:15 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57237 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756520AbZCARAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 12:00:14 -0500
Date: Sun, 1 Mar 2009 11:00:10 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>, hch@infradead.org
Subject: Re: [RFC][PATCH 8/8] check files for checkpointability
Message-ID: <20090301170010.GC18867@us.ibm.com>
References: <20090227203425.F3B51176@kernel> <20090227203435.98735E54@kernel> <20090228025743.GA22451@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090228025743.GA22451@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sukadev Bhattiprolu (sukadev@linux.vnet.ibm.com):
> Dave Hansen [dave@linux.vnet.ibm.com] wrote:
> | 
> | Introduce a files_struct counter to indicate whether a particular
> | file_struct has ever contained a file which can not be
> | checkpointed.  This flag is a one-way trip; once it is set, it may
> | not be unset.
> | 
> | We assume at allocation that a new files_struct is clean and may
> | be checkpointed.  However, as soon as it has had its files filled
> | from its parent's, we check it for real in __scan_files_for_cr().
> | At that point, we mark it if it contained any uncheckpointable
> | files.
> 
> Hmm. Why not just copy ->may_checkpoint setting from parent (or old)
> files_struct ? If parent is not checkpointable, then child won't be
> and vice-versa - no ?

No.  We don't clear the files_struct checkpointable flag when an
uncheckpointable file is closed.  But if the parent has closed
all uncheckpointable files before forking, then the child can
be started with a checkpointable files_struct.

Otherwise it wouldn't just be the task which has a one-way trip to
uncheckpointability, but process trees, and - assuming init does
anything uncheckpointable at all - the whole system :)

-serge
