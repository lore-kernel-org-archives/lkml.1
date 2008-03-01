Return-Path: <linux-kernel-owner+w=401wt.eu-S1761795AbYCAAmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761795AbYCAAmX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYCAAmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:42:06 -0500
Received: from web36613.mail.mud.yahoo.com ([209.191.85.30]:37474 "HELO
	web36613.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752683AbYCAAl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:41:56 -0500
X-YMail-OSG: yE5nyBQVM1kC9z4k1gqi9o6jwr6lwi_tsIoMnaQlNMqIrYSKpQGINjCVVswBwmFReVVXU6xTxQ--
X-RocketYMMF: rancidfat
Date: Fri, 29 Feb 2008 16:41:52 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 01/11] Security: Add hook to get full maclabel xattr name
To: Trond Myklebust <trond.myklebust@fys.uio.no>, casey@schaufler-ca.com
Cc: Christoph Hellwig <hch@infradead.org>,
       Dave Quigley <dpquigl@tycho.nsa.gov>,
       Stephen Smalley <sds@tycho.nsa.gov>, viro@ftp.linux.org.uk,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org,
       LSM List <linux-security-module@vger.kernel.org>
In-Reply-To: <1204330146.8237.24.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <245411.88940.qm@web36613.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:

> 
> On Fri, 2008-02-29 at 13:07 -0800, Casey Schaufler wrote:
> > --- Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > 
> > > On Fri, 2008-02-29 at 10:52 -0800, Casey Schaufler wrote:
> > > > So it sounds as if for an xattr protocol to be viable it would first
> > > > require that xattr semantics be generally accepted (POSIX definition
> > > > would suffice), that there be multiple implementations (Linux and Irix
> > > > could suffice should Irix still be around when POSIX is done), and
> > > > that there be a perceived need beyond that of the Lunitic Fringe
> > > > Security Community.
> > > 
> > > The problem isn't that of supporting the naive user xattr model: we can
> > > almost do that within the existing 'named attribute' model of NFSv4. The
> > > problem is that of supporting the arbitrary "security metadata" that are
> > > allowed to have side-effects on the system behaviour, and that we appear
> > > to have thought was a good idea to overload onto the xattr interface.
> > 
> > Hum. Security metadata was one of the justifications for the
> > original implementation of the xattr interface for XFS at SGI.
> > The implementation was intended to be generic and allow for
> > storage of data that impacts system behavior. No, it is not
> > overloading at all, it is really supposed to be used that way.
> > That's how it works on CXFS, which I know is still proprietary,
> > but which could become an open peer of NFS someday.
> 
> Historical accidents change nothing to my argument. I still don't like
> to be confusing user xattrs (which is a _storage_ issue) and the
> security metadata (part of a _control_ protocol).

Twould appear that our mindsets are not in harmony.

> Nor do I see a compelling need to repeat any design mistakes that CXFS
> might have made in this area...

Oh, CXFS made mistakes, but I don't think this is one of them.
But it appears we have sufficient fundimental differences that
we'd agree on much of the list.

> > Yes, I can see that having a specific interface reduces the
> > documentation required, and simplifies it as well. Unfortunately,
> > given the way that a secctx is defined for either SELinux or
> > Smack, and the fact that the relationships between secctx values
> > are defined independently on the server and client* it does not
> > appear that the interoperability issue has been addressed, or
> > even really acknowleged with the proposed scheme. Yes, the issue
> > of label translation has been acknowleged, but it appears to me
> > that a day one solution is required for the scheme to be useful.
> 
> What would your expectation be for a SMACK-based client, if it mounts
> from a server that turns out to be running with an SELinux security
> model, or vice versa?

This is a fun Friday afternoon exercise:

- SELinux server, Smack client:

Client sends "MyDogHasNoNose" to server.
Server determines that is not a value secctx as far as it knows
returns appropriate error.

Client sends "sysadm_t:so,c1,2" (some understood SELinux context) to server.
Server makes access check, goes ahead, even though the meaning of
the secctx may be unrelated.

On file creation, the file may get a secctx that the client would
not expect. Client would deny access unless the client has a rule
allowing that access.

- Smack server, SELinux client:

Client sends "sysadm_t:so,c1,2" to the server. Access checks are
made with that string. New files will get created with that label.
So long as there's a directory into which a process with that label
can write it should work with Smack semantics.

- So ...

Either could be made to function somewhat if the Smack rules
and labels got set properly. I can't claim to say that you
couldn't set up the SELinux side to accomodate the Smack labels,
but I don't think it would be easy if you can.

I think it would be a really really bad idea for anyone to
try this without both Stephen and me in the room. Dave should
be there too, so he can watch if the atmosphere catches fire.

I think that the general answer is that it wouldn't work,
but with the fate of the universe at stake and a big budget
hollywood production you could make something limp along.


Casey Schaufler
casey@schaufler-ca.com
