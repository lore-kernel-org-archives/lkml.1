Return-Path: <linux-kernel-owner+w=401wt.eu-S1752861AbZC3Ml5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861AbZC3Ml5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751194AbZC3Mlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:41:46 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:58344 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZC3Mlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:41:45 -0400
Subject: Re: Zero length files - an alternative approach?
From: Chris Mason <chris.mason@oracle.com>
To: =?ISO-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
In-Reply-To: <yw1xab744lqi.fsf@thrashbarg.mansr.com>
References: <87bprka9sg.fsf@newton.gmurray.org.uk>
	 <yw1xab744lqi.fsf@thrashbarg.mansr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Mar 2009 08:41:26 -0400
Message-Id: <1238416886.30488.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.49D0BDF9.00E7:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-29 at 12:22 +0100, Måns Rullgård wrote:
> Graham Murray <graham@gmurray.org.uk> writes:
> 
> > Just a thought on the ongoing discussion of dataloss with ext4 vs ext3.
> >
> > Taking the common scenario:
> > Read oldfile
> > create newfile file
> > write newfile data
> > close newfile
> > rename newfile to oldfile
> >
> > When using this scenario, the application writer wants to ensure that
> > either the old or new content are present. With delayed allocation, this
> > can lead to zero length files. Most of the suggestions on how to address
> > this have involved syncing the data either before the rename or making
> > the rename sync the data.
> >
> > What about, instead of 'bringing forward' the allocation and flushing of
> > the data, would it be possible to instead delay the rename until after
> > the blocks for newfile have been allocated and the data buffers flushed?
> > This would keep the performance benefits of delayed allocation etc and
> > also satisfy the applications developers' apparent dislike of using
> > fsync(). It would give better performance that syncing the data at
> > rename time (either using fsync() or automatically) and satisfy the
> > requirements that either the old or new content is present.
> 
> Consider this scenario:
> 
> 1. Create/write/close newfile
> 2. Rename newfile to oldfile

2a. create oldfile again
2b. fsync oldfile

> 3. Open/read oldfile.  This must return the new contents.
> 4. System crash and reboot before delayed allocation/flush complete
> 5. Open/read oldfile.  Old contents now returned.
> 

What happens to the new generation of oldfile?  We could insert
dependency tracking so that we know the fsync of oldfile is supposed to
also fsync the rename'd new file.  But then picture a loop of operations
doing renames and creating files in the place of the old one...that
dependency tracking gets ugly in a hurry.

Databases know how to do all of this, but filesystems don't implement
most of the database transactional features.

-chris


