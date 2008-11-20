Return-Path: <linux-kernel-owner+w=401wt.eu-S1758200AbYKTU4Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758200AbYKTU4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 15:56:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757579AbYKTUxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 15:53:00 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:42333 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757578AbYKTUw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 15:52:58 -0500
Subject: Re: [PATCH 3/4] integrity: IMA as an integrity service provider
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Al Viro <viro@ZenIV.linux.org.uk>,
       David Safford <safford@watson.ibm.com>,
       Serge Hallyn <serue@linux.vnet.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20081120181523.GA4444@infradead.org>
References: <cover.1227137423.git.zohar@linux.vnet.ibm.com>
	 <342f87b65eae2369d96501d8d4935d6be0f46678.1227137423.git.zohar@linux.vnet.ibm.com>
	 <20081120181523.GA4444@infradead.org>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 15:52:51 -0500
Message-Id: <1227214371.2819.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 13:15 -0500, Christoph Hellwig wrote:

> > +		if (!rc) {
> > +			if (atomic_read(&(data->dentry->d_count)) - 1 >
> > +			    atomic_read(&(inode->i_writecount)))
> > +				ima_add_violation(inode, data->filename,
> > +						  "invalid_pcr", "ToMToU");
> > +		}
> 
> > +			if (atomic_read(&(inode->i_writecount)) > 0)
> > +				ima_add_violation(inode, data->filename,
> > +						  "invalid_pcr",
> > +						  "open_writers");
> 
> All these d_count and i_writecount access needs a lot of explanation,
> they certainly don't make sense as-is, but I'd like to find out what
> you're actually trying to do here.

The OS protects against an executable file, already open for write, from
being executed; and an executable file, open for execute, from being
modified.  In the same vein, we want to know that the file measured is
the same file read, that it hasn't been modified.  So, if a file already
open for read is then opened for write, we log it with a "Time of
Measure, Time of Use" error (ToMToU) and invalidate the PCR. Or, if a
file already open for write is then opened for read, we log the fact
that the file could change while being read and invalidate the PCR.

This is important when measuring configuration files, shell scripts (not
measured in brpm_check_integrity which are protected by the OS), and
files imported/included by scripts.

Mimi

