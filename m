Return-Path: <linux-kernel-owner+w=401wt.eu-S1754133AbZC3OHX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbZC3OHX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 10:07:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbZC3OHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 10:07:08 -0400
Received: from THUNK.ORG ([69.25.196.29]:57019 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbZC3OHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 10:07:07 -0400
Date: Mon, 30 Mar 2009 10:06:59 -0400
From: Theodore Tso <tytso@mit.edu>
To: Chris Mason <chris.mason@oracle.com>
Cc: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
       linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: Zero length files - an alternative approach?
Message-ID: <20090330140659.GH13356@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Chris Mason <chris.mason@oracle.com>,
	=?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <87bprka9sg.fsf@newton.gmurray.org.uk> <yw1xab744lqi.fsf@thrashbarg.mansr.com> <1238416886.30488.6.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1238416886.30488.6.camel@think.oraclecorp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 08:41:26AM -0400, Chris Mason wrote:
> > 
> > Consider this scenario:
> > 
> > 1. Create/write/close newfile
> > 2. Rename newfile to oldfile
> 
> 2a. create oldfile again
> 2b. fsync oldfile
> 
> > 3. Open/read oldfile.  This must return the new contents.
> > 4. System crash and reboot before delayed allocation/flush complete
> > 5. Open/read oldfile.  Old contents now returned.
> > 
> 
> What happens to the new generation of oldfile?  We could insert
> dependency tracking so that we know the fsync of oldfile is supposed to
> also fsync the rename'd new file.  But then picture a loop of operations
> doing renames and creating files in the place of the old one...that
> dependency tracking gets ugly in a hurry.

If there are any calls to link(2) to create hard links to oldfile or
newfile intermingled in this sequence, life also gets very
entertaining.

> Databases know how to do all of this, but filesystems don't implement
> most of the database transactional features.

Yep, we'd have to implement a rollback log to get this right, which
would also impact performance.  My guess is that just aggressively
forcing out the data write before the rename() is going to cost less
in performance, and is certainly much easier to implement.

   		       		      	     - Ted
