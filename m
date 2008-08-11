Return-Path: <linux-kernel-owner+w=401wt.eu-S1756717AbYHKTJh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717AbYHKTJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 15:09:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbYHKTJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 15:09:14 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:41970 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035AbYHKTJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 15:09:11 -0400
In-Reply-To: <20080811170255.GA2662@us.ibm.com>
References: <20080808184349.999902616@linux.vnet.ibm.com> <1218221761.4444.13.camel@localhost.localdomain> <20080809185340.GC22905@infradead.org> <OF0AEBDCA2.1E27B823-ON852574A1.000FEE48-852574A1.004C3185@us.ibm.com> <20080811170255.GA2662@us.ibm.com>
To: serue@linux.vnet.ibm.com
Cc: Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>, safford@watson.ibm.com,
       sailer@watson.ibm.com, Stephen Smalley <sds@tycho.nsa.gov>,
       serue@linux.vnet.ibm.com, Al Viro <viro@ZenIV.linux.org.uk>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/4] integrity: Linux Integrity Module(LIM)
X-KeepSent: AC0E3107:C68382CD-852574A2:0068E1AD;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.0.1 February 07, 2008
Message-ID: <OFAC0E3107.C68382CD-ON852574A2.0068E1AD-852574A2.00692623@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Mon, 11 Aug 2008 15:08:36 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Build V85_M1_05262008|May 26, 2008) at
 08/11/2008 15:08:37,
	Serialize complete at 08/11/2008 15:08:37
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

serue@linux.vnet.ibm.com wrote on 08/11/2008 01:02:55 PM:

> Quoting Mimi Zohar (zohar@us.ibm.com):
> > Christoph Hellwig <hch@infradead.org> wrote on 08/09/2008 02:53:40 PM:
> > > >  int vfs_permission(struct nameidata *nd, int mask)
> > > >  {
> > > > -   return inode_permission(nd->path.dentry->d_inode, mask);
> > > > +   int retval;
> > > > +
> > > > +   retval = inode_permission(nd->path.dentry->d_inode, mask);
> > > > +   if (retval)
> > > > +      return retval;
> > > > +   return integrity_inode_permission(NULL, &nd->path,
> > > > +                 mask & (MAY_READ | MAY_WRITE |
> > > > +                    MAY_EXEC));
> > > >  }
> > > > 
> > > >  /**
> > > > @@ -306,7 +314,14 @@ int vfs_permission(struct nameidata *nd,
> > > >   */
> > > >  int file_permission(struct file *file, int mask)
> > > >  {
> > > > -   return inode_permission(file->f_path.dentry->d_inode, mask);
> > > > +   int retval;
> > > > +
> > > > +   retval = inode_permission(file->f_path.dentry->d_inode, mask);
> > > > +   if (retval)
> > > > +      return retval;
> > > > +   return integrity_inode_permission(file, NULL,
> > > > +                 mask & (MAY_READ | MAY_WRITE |
> > > > +                    MAY_EXEC));
> > > 
> > > Please put your hook into inode_permission.  Note that in inode
> > > permission and lots of callers there is no path available so don't 
pass
> > > it.  Please pass the full MAY_FOO mask for new interfaces and do
> > > filtering that won't break if new ones are introduced.
> > 
> > We started out with the integrity_inode_permission() hook call in 
> > inode_permission(), but because of the removal of the nameidata 
> > parameter in the last merge, based on discussions
> > http://marc.info/?l=linux-security-module&m=121797845308246&w=2,
> > the call to integrity_inode_permission() was moved up to the caller,
> > where either a file or path are available.  Any suggestions?
> 
> Mimi, can you explain exactly (and concisely) what you are doing with
> the pathname?

IMA maintains a list of hash values of system sensitive files loaded 
into the run-time of the system and extends a PCR with the hash value. 
In order to calculate this hash value, IMA requires access to either
the file or the path, which currently is not accessible in 
inode_permission().

Mimi
