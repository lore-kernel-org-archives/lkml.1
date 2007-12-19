Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXLSFjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXLSFjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 00:39:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXLSFjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 00:39:35 -0500
Received: from web36607.mail.mud.yahoo.com ([209.191.85.24]:32098 "HELO
	web36607.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751325AbXLSFje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 00:39:34 -0500
X-YMail-OSG: WpeaIEcVM1lz82lAqz4Ll0q3Yi8gaKixYFuzwN_oWPyMlEPSXp3.E3NWCCaTTq02LpjqL.86ROS4u4YiL5FNCfWn7ddHhwIHk1kU2WCVbHn3aWN.yMI-
X-RocketYMMF: rancidfat
Date: Tue, 18 Dec 2007 21:39:33 -0800 (PST)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH 08/28] SECURITY: Allow kernel services to override LSM settings for task actions [try #2]
To: Crispin Cowan <crispin@crispincowan.com>,
       Stephen Smalley <sds@tycho.nsa.gov>
Cc: David Howells <dhowells@redhat.com>, Karl MacMillan <kmacmill@redhat.com>,
       viro@ftp.linux.org.uk, hch@infradead.org, Trond.Myklebust@netapp.com,
       casey@schaufler-ca.com, linux-kernel@vger.kernel.org,
       selinux@tycho.nsa.gov, linux-security-module@vger.kernel.org,
       apparmor-dev <apparmor-dev@forge.novell.com>
In-Reply-To: <47688FEA.9070905@crispincowan.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <348885.22957.qm@web36607.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Crispin Cowan <crispin@crispincowan.com> wrote:

> Stephen Smalley wrote:
> >> It is if I have to maintain a special pieces of code for each possible
> LSM.
> >> One piece for SELinux, one piece for AppArmour, one piece for Smack, one
> piece
> >> for Casey's security system.  That sounds like a pain.

It's probably less of a pain if you consider that Casey's
security scheme is Smack.

> > All your code has to do is invoke a function provided by libselinux.  If
> > at some later time a liblsm is introduced that provides a common
> > front-end to a libselinux, libsmack, ..., then you can use that.  But it
> > doesn't exist today.   But it all just becomes a simple function call
> > regardless.
> >   
> libapparmor exists. It only had one API, and now it has 2, but just 2
> versions on the same concept (change_hat and change_profile).
> 
> This is the API for change_hat http://man-wiki.net/index.php/2:change_hat
> 
> What does the corresponding API in SELinux look like?

The POSIX mac_set_proc(mac_t label) might work for this interface.
Sets the current process MAC attribute, if appropriate. The Smack
implementation would be pretty easy:

typedef char * mac_t;

int mac_set_proc(mac_t label)
{
        int fd;
        int rc;

        rc = strlen(label);
        if (rc > SMACK_MAX_LABEL_LEN)
                return -1;
        fd = open("/proc/self/attr/current", O_RDWR);
        if (fd < 0)
                return -1;
        rc = write(fd, label, rc);
        close(fd);
        if (rc < 0)
                return -1;
        return 0;
}


Casey Schaufler
casey@schaufler-ca.com
