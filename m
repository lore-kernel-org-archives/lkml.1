Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZHNNcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZHNNcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 09:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZHNNcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 09:32:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52991 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbZHNNcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 09:32:47 -0400
Date: Fri, 14 Aug 2009 08:32:25 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Will Drewry <redpig@dataspill.org>
Cc: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       linux-security-module@vger.kernel.org, morgan@kernel.org,
       David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 1/1] support optional non-VFS capability
	inheritance without disabling file caps
Message-ID: <20090814133225.GB27905@us.ibm.com>
References: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (redpig@dataspill.org):
> Capabilities marked as inheritable (+i) are inaccessible when inherited
> by a child process (after exec()) with CONFIG_SECURITY_FILE_CAPABILITIES
> enabled unless the VFS entry of the child also provides the capability (or
> cap_setpcap) in the permitted/effective sets.
> 
> This change adds a securebit, SECURE_INHERIT_CAPS, which enableѕ
> inherited capabilities to be propagated to the permitted set of the
> child process.  If it doesn't conflict with VFS_CAP_FLAGS_EFFECTIVE, it
> will also mark the capabilities effective.  This bit and change only
> take effect when SECURE_NOROOT is set.
> 
> The securebit guard is used because this change violates the following
> constraint:
>         pP' = (X & fP) | (pI & fI)
> With bit-6 enabled, the constraint becomes:
>         pP' = (X & fP) | (pI)
> and pE' varying based on VFS bits and if there are any file-based capabilities.
> 
> This allows for a purely runtime capabilities-based environment without
> requiring every file to be annotated with an extended attribute.  This

Well, we have that ability now - only files which need to be executed
*with* *privilege* need an xattr.

> also means that SECURE_NOROOT process trees using capabilities become
> more accessible, especially for filesystems without extended attribute
> support - or in mixed FS environments.

<sigh>  Well, this *is* a problem.  I wonder whether perhaps we should
instead be trying to either think of a way to specify file capabilties
on non-xattr file systems, or working harder to provide xattrs
everywhere.

Heck, maybe we can use the fscache or a stackable fs to provide a view
of a non-xattr fs with xattrs layered on top.  David Howells, does
that sound doable or would that be an abuse?

Will, let me be sure we're on the same page - you don't want this feature
bc you don't want to go through the trouble of adding file capabilities
to the executables which need and deserve it, but because in your
environment you have an FS which doesn't support file caps and so
there is no way for you to have a SECURE_NOROOT|SECURE_NOSUID_FIXUP
environment because you need to run a privileged program off of the
non-xattr fs?

> For example, a daemon like dhcpcd may be launched with cap_net_raw by a
> more privileged daemon.  Once dhcpcd drops the cap_net_raw privilege, it
> will not be able to regain it.  Even if a local user runs dhcpcd
> manually, the capability will not be granted because the capability was
> not derived from the filesystem.  However, the calling capability
> manager could either gain its permissions from init or by having a
> file-based capability set.
> 
> Nb, I may be missing something obvious - any insights will be appreciated,
>     and there is a good bit of flexibility in what can be done here.

I don't know whether or not you're missing something, but of course
what we give up with your patch is the feature that all privilege to
a process is in the end granted by the executable.  I'll admit that
of the like patches I've seen, yours makes the most sense.  My main
concern would be that it would make things more confusing, so if we
can fix the problem another way, without adding yet another set of
semantics, that would be preferable.  However if that is not feasible,
I might be inclined to ack this.

thanks,
-serge
