Return-Path: <linux-kernel-owner+w=401wt.eu-S932550AbZKMXIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550AbZKMXIU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 18:08:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932477AbZKMXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 18:08:13 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:37153 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932472AbZKMXIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 18:08:12 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Julia Lawall <julia@diku.dk>
Cc: Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] security/selinux: decrement sizeof size in strncmp
In-Reply-To: Your message of "Fri, 13 Nov 2009 22:26:20 +0100."
             <Pine.LNX.4.64.0911132224370.6325@ask.diku.dk>
From: Valdis.Kletnieks@vt.edu
References: <Pine.LNX.4.64.0911120849050.16627@ask.diku.dk> <alpine.LRH.2.00.0911121857110.31071@tundra.namei.org> <20091112145314.GA24682@us.ibm.com> <Pine.LNX.4.64.0911121556390.19779@ask.diku.dk> <4AFC3620.2020809@schaufler-ca.com> <alpine.LRH.2.00.0911130833220.5497@tundra.namei.org> <4AFCC06B.1030302@schaufler-ca.com> <19857.1258147396@turing-police.cc.vt.edu>
            <Pine.LNX.4.64.0911132224370.6325@ask.diku.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1258153693_3022P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Nov 2009 18:08:13 -0500
Message-ID: <24306.1258153693@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.14.107 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020204.4AFDE6DD.014B,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1258153693_3022P
Content-Type: text/plain; charset=us-ascii

On Fri, 13 Nov 2009 22:26:20 +0100, Julia Lawall said:
> On Fri, 13 Nov 2009, Valdis.Kletnieks@vt.edu wrote:
> > Julia, is there a way to use coccinelle to detect unsafe changes like that?  Or
> > is expressing those semantics too difficult?
> 
> Could you give a concrete example of something that would be a problem?
> If something like alias analysis is required, to know what strings a 
> variable might be bound to, that might be difficult.  Coccinelle works 
> better when there is some concrete codeto match against.

Here's a concrete example of how a previously audited strcmp() can go bad...

struct foo {
    char[16] a; /* old code allows 15 chars and 1 more for the \0 */
    int b;
    int c;
}

bzero(foo,sizeof(foo));

Now code can pretty safely mess with the first 15 bytes of foo->a and
we know we're OK if we call strcmp(foo->a,....) because that bzero()
nuked a[15] for us. It's safe to strncpy(foo->a,bar,15); and not worry
about the fact that if bar is 15 chars long, a trailing \0 won't be put in.

Now somebody comes along and does:

struct foo {
    char *a; /* we need more than 15 chars for some oddball hardware */
    int b;
    int c;
}

bzero(foo,sizeof(foo));
foo->a = kmalloc(32);  /* whoops should have been kzmalloc */

Now suddenly, strncpy(foo->a,bar,31); *isn't* safe....

(Yes, I know there's plenty of blame to go around in this example - the failure
to use kzmalloc, the use of strncpy() without an explicit \0 being assigned
someplace, the use of strcmp() rather than strncmp()... But our tendency to
intentionally omit several steps of this to produce more efficient code means
it's easier to shoot ourselves in the foot...)


--==_Exmh_1258153693_3022P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK/ebdcC3lWbTT17ARAq8pAKC4w21JS88AQ2QVaPk79sivFBQd4ACeJnN4
Uf1cDnloW2vx0Tqypq9HJzY=
=cbTA
-----END PGP SIGNATURE-----

--==_Exmh_1258153693_3022P--

