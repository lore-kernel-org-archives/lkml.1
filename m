Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbZIIR6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbZIIR6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZIIR6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:58:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbZIIR6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:58:16 -0400
Date: Wed, 9 Sep 2009 13:57:54 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090909135754.7df7b93e@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909091333050.32067@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
	<20090909125352.1c7b57d2@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091304001.32067@V090114053VZO-1>
	<20090909132039.1ca47cd4@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091333050.32067@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 13:33:33 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 9 Sep 2009, Jeff Layton wrote:
> 
> > Unfortunately I doubt there's much you can do from your client to
> > prevent that (if that is the case). There may be a way to turn off
> > oplocks on the server side, but that may very well be even worse for
> > performance.
> 
> Also note that these hiccups occur when simply doing an
> 
> 	ls
> 
> we are not accessing or writing files.
> 

Hmm...

The hiccups you posted in the original email happened during a
QPathInfo call (somewhat similar to a NFS GETATTR). I wouldn't think
that would cause an oplock break, but I suppose it might. The server
might decide that it needs to revoke the oplock in order to retrieve
accurate size, LastWriteTime (aka mtime), etc. It could also be a
windows bug...

Here's an excerpt from an IRC conversation on this in #samba-technical, that might give a little info:

13:42 < jlayton> would a QPathInfo call cause an oplock break?
13:42 < jlayton> (typically)?
13:47 < sdann> jlayton, no it shouldn't, as it's path based and could be done with a stat() call.  Only an open() or brl() 
               operation should break an oplock.
13:48 < jlayton> ok, good to know -- thx
13:49 < jlayton> sdann: actually though, I'm asking about win2k3 server...
13:49 < jlayton> do you know whether it might break the oplock on a qpathinfo?
13:49 < jlayton> i.e. to get accurate size info, for instance
13:50 < sdann> well in general, only opens, writes (truncate included), and byte-range-lock ops break oplocks
13:50 < sdann> so any kind of meta-data request should not
13:51 < jlayton> hmm ok, one of the linux-kernel guys is seeing QPathInfo calls go out to win2k3 server and the server waits 
                 5s before responding
13:51 < jlayton> my initial thought was oplock break to another client is causing the stall, but maybe it's something else
13:51 < coffeedude> sdann, SetFileInfo (allocationInfo and EndofFile) will as well.
13:51 < jlayton> I'm pretty sure this is QPathInfo call
13:52 < sdann> a quick torture test in source4/torture/raw/oplock.c would solve the issue :)
13:52 < coffeedude> jlayton, internally in Windows, the NTFS interface is handle based so I assume the server does a 
                    NtCreateFile(), QueryInformationFile(), CloseFile(). 
13:52 < jlayton> ahhh maybe so
13:52 < coffeedude> jlayton, the internal opens should done with FILE_READ_ATTRIBUTES so they don't cause a break but it 
                    could be a Windows bug.
13:53 < jlayton> sounds plausible
13:53 < jlayton> coffeedude, sdann: thanks!
13:53 < coffeedude> jlayton, any open with nothing other than FILE_READ_ATTRIBUTES, FILE_WRITE_ATTRIBUTES or SYNCHRONIZE 
                    should nto cause an oplock break either.
13:53 < sdann> coffeedude, yeah that's certainly possible
13:53 < coffeedude> jlayton, any open with nothing other than FILE_READ_ATTRIBUTES, FILE_WRITE_ATTRIBUTES or SYNCHRONIZE 
                    should nto cause an oplock break either.
13:53 < sdann> coffeedude, yeah that's certainly possible
13:53 < coffeedude> sdann, only know cause I've done it :)

I'd probably start with sniffing traffic at the server side and see if
you can correlate the stalls with traffic to other hosts (oplock breaks
in particular).

If so then maybe consider patching the server or testing with a
different flavor of windows.

-- 
Jeff Layton <jlayton@redhat.com>
