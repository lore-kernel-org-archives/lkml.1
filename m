Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZBXAar@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZBXAar (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:30:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZBXAag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:30:36 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:33262 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754000AbZBXAaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:30:35 -0500
Subject: Re: [RFC][PATCH 3/5] check files for checkpointability
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090223234911.GB2590@us.ibm.com>
References: <20090219182007.B4B47C1F@kernel>
	 <20090219182009.1A3E8860@kernel>  <20090223234911.GB2590@us.ibm.com>
Content-Type: text/plain
Date: Mon, 23 Feb 2009 16:30:30 -0800
Message-Id: <1235435430.26788.212.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 17:49 -0600, Serge E. Hallyn wrote:
> Quoting Dave Hansen (dave@linux.vnet.ibm.com): 
> > Introduce a files_struct counter to indicate whether a particular
> > file_struct has ever contained a file which can not be
> > checkpointed.  This flag is a one-way trip; once it is set, it may
> > not be unset.
> > 
> > We assume at allocation that a new files_struct is clean and may
> > be checkpointed.  However, as soon as it has had its files filled
> > from its parent's, we check it for real in __scan_files_for_cr().
> > At that point, we mark it if it contained any uncheckpointable
> > files.
> > 
> > We also check each 'struct file' when it is installed in a fd
> > slot.  This way, if anyone open()s or managed to dup() an
> > unsuppored file, we can catch it.
> 
> So what is the point of tagging the files_struct counter and
> making it a one-way trip?  Why not just check every file at
> checkpoint time?

We need both.

This allows us to tell where and when we went wrong.  Take a process
that's been running for a month.  After 5 days it did something random
to keep it from being checkpointed.  You're going to have forgotten all
about it 25 days later.  This gives us an opportunity to spit into dmesg
or just plain log it.  It also gives the app some ability to reflect and
see what its uncheckpointable attributes are.  

-- Dave

