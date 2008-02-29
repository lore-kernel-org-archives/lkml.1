Return-Path: <linux-kernel-owner+w=401wt.eu-S1760110AbYB2BQL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110AbYB2BQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 20:16:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYB2BPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 20:15:51 -0500
Received: from namei.org ([69.55.235.186]:40186 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750991AbYB2BPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 20:15:50 -0500
Date: Fri, 29 Feb 2008 12:15:05 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Dave Quigley <dpquigl@tycho.nsa.gov>
cc: Christoph Hellwig <hch@infradead.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       casey@schaufler-ca.com, viro@ftp.linux.org.uk,
       trond.myklebust@fys.uio.no, bfields@fieldses.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
In-Reply-To: <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
Message-ID: <Xine.LNX.4.64.0802291155160.28680@us.intercode.com.au>
References: <746385.69480.qm@web36611.mail.mud.yahoo.com> 
 <1204227035.31790.207.camel@moss-spartans.epoch.ncsc.mil> 
 <20080228234850.GA25829@infradead.org> <1204243497.2715.24.camel@moss-terrapins.epoch.ncsc.mil>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Feb 2008, Dave Quigley wrote:

> There are several things here. I've spoken to several people about this
> and the belief I've gotten from most of them is that a recommended
> attribute is how this is to be transported. The NFSv4 spec people will
> probably say that if you want xattr like functionality for NFSv4 use
> named attributes.

NAs are a non-starter here for a couple of reasons.

1. They are specified as being user managed and opaque to NFS.  MAC 
labels are typically set by the OS, and may only be set by the user when 
permitted by MAC policy.  The labels need to be interpreted by the OS to 
allow MAC policy to be enforced.

2. The NA namespace is arbitrary and opaque to the OS.  There's no scope 
in NFSv4 design to allow a namespace to be specified for e.g. MAC labels, 
and trying to modify the spec to allow it seems impractical to me.  It 
would at the very least break backward compatibility with clients and 
servers, and lead to some ugly hacks to try and ensure that systems were 
reliably speaking to peers which understood the namespace.

It might be possible to implement Linux/BSD style xattrs for NFSv4, 
assuming that the IETF folk would approve of the idea, but I don't think 
this is really the right solution for conveying MAC labels across the 
wire.  The xattr API as a local interface is pretty good for this (as it 
is FS independent, simple, and established), but that does not 
automatically translate to an xattr wire protocol being the right thing. 
The problem with this, I believe, is that you end up with quite a lot of 
overhead and complexity being added to NFSv4 which does not actually meet 
the requirements of MAC labeling, and like NAs, seems more suited 
for arbitrary user-managed metdata.

Using RAs for MAC labels seems most appropriate, as they're simple, 
extensible and already used for similar protocol attributes such as ACLs, 
and other system-managed metadata.


- James
-- 
James Morris
<jmorris@namei.org>
