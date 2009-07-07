Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZGGTmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZGGTmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 15:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754647AbZGGTmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 15:42:24 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43008 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbZGGTmY (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 15:42:24 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@dmesg.printk.net
Subject: Re: fanotify: the fscking all notification system
In-Reply-To: Your message of "Tue, 30 Jun 2009 13:26:37 EDT."
             <1246382797.22562.16.camel@dhcp235-23.rdu.redhat.com>
From: Valdis.Kletnieks@vt.edu
References: <1246306125.754.300.camel@dhcp235-23.rdu.redhat.com> <22424.1246368155@turing-police.cc.vt.edu>
            <1246382797.22562.16.camel@dhcp235-23.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1246995702_3905P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 07 Jul 2009 15:41:42 -0400
Message-ID: <63598.1246995702@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1246995702_3905P
Content-Type: text/plain; charset=us-ascii

On Tue, 30 Jun 2009 13:26:37 EDT, Eric Paris said:

(Sorry for the late reply...)

> Yes.  Although it going to take just a tiny bit of work from me and you
> are limited in how to use it.
> 
> You'll need to request FAN_OPEN_PERM on the file in question.  When the
> file is opened you will need to bring in all the data and write all that
> data into the file.  There is no mechanism to only bring in a piece of a
> file since you have no way of knowing what exactly the requesting
> process is requesting.   So it's a whole file or nothing type of deal.

That's OK - most current HSM implementations work that way already - if they
archive a file, they write out a little stub that basically says "The data is
on tape 948324, file 3342", and on access, the entire file is retrieved.

The only problem is that when we finally return control to the user program,
we need to have wiped out that stub and replaced it with the user's data.

> Current problems:
> 
> 1) the fd the fanotify listener gets is O_RDONLY.  I think I'll add an
> "f_flags" option which if 0 defaults to O_RDONLY|O_LARGEFILE like we
> have today but which you could use to indicate O_RDWR or O_WRONLY.  We
> currently give O_RDONLY since you can't request O_WR* on files/libraries
> mapped exec, so this won't work for executables.....

Having only O_RDONLY is a show-stopper, because then we can't replace the file
contents before continuing.  For many places, the executables and shared
libraries aren't the problem, so "You can't HSM an executable" as a
semi-permanent restriction isn't too bad.

It's the terabytes of data files that are usually the issue - everything from
4-year-old Word documents to video (actual use case - a transportation safety
group here is instrumenting several hundred tractor-trailers with a dozen
cameras that are all rolling at all times the engine is on. That's a lot of
archival video).  An HSM would want O_RDWR for those - RD so it can check and
see if there's a archival stub present, and then WR to restore the file with.

> 2) Right now you have 5 seconds to answer an fanotify permissions
> request, if you don't get it in 5 seconds you are done and the original
> process gets an allow.  But I have a half finished patch which would
> allow you to delay them infinitely.  As long as you keep them delayed
> you can modify the file they are about to access however you like.

That would work fine.

> You can not rename over the fd you are given, you have to actually copy
> the data into that fd, since the inode behind the fd you got from
> fanotify is the same inode the original process is going to get access
> to after your listener sends an allow.

That's an acceptable restriction as well.

> This sound good to you?  I don't know your details, but I believe that
> fanotify directed mode with access permissions is going to be almost
> exactly what you want....

Yes, it's sounding like it. If that's in mainstream, then I can deploy an HSM
without needing kernel hackery like most do currently.



--==_Exmh_1246995702_3905P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFKU6T2cC3lWbTT17ARAnvEAKDjcN03taaw+Ls1EJuTkA2cCKAb4gCgsbCe
72pWOCE6gausPvfeOLibMmY=
=aRqc
-----END PGP SIGNATURE-----

--==_Exmh_1246995702_3905P--
