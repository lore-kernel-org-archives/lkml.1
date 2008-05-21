Return-Path: <linux-kernel-owner+w=401wt.eu-S932331AbYEUKZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331AbYEUKZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 06:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756086AbYEUKZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 06:25:39 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:43680 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbYEUKZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 06:25:38 -0400
Message-ID: <4833F89F.7080707@kerlabs.com>
Date: Wed, 21 May 2008 12:25:35 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
Organization: Kerlabs
User-Agent: IceDove 1.5.0.14pre (X11/20071018)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Arjan van de Ven <arjan@infradead.org>,
       Joel Becker <Joel.Becker@oracle.com>, linux-kernel@vger.kernel.org,
       ocfs2-devel@oss.oracle.com
Subject: Re: [RFC][PATCH 0/3] configfs: Make nested default groups	lockdep-friendly
References: <20080520163320.025971210@kerlabs.com>	 <20080520095810.1d50d247@infradead.org>	 <20080520215639.GG26609@mail.oracle.com>	 <20080520151341.058f2df4@infradead.org> <1211361784.6463.68.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1211361784.6463.68.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Peter Zijlstra a écrit :
> On Tue, 2008-05-20 at 15:13 -0700, Arjan van de Ven wrote:
>> On Tue, 20 May 2008 14:56:39 -0700
>> Joel Becker <Joel.Becker@oracle.com> wrote:
>>
>>> On Tue, May 20, 2008 at 09:58:10AM -0700, Arjan van de Ven wrote:
>>>> On Tue, 20 May 2008 18:33:20 +0200
>>>> Louis Rilling <Louis.Rilling@kerlabs.com> wrote:
>>>>
>>>>> The following patches fix lockdep warnings resulting from
>>>>> (correct) recursive locking in configfs.
>>>>>
>>>>> ...
>>>>>
>>>>> Since lockdep does not handle such correct recursion, the idea is
>>>>> to insert lockdep_off()/lockdep_on() for inode mutexes as soon as
>>>>> the level of recursion of the I_MUTEX_PARENT -> I_MUTEX_CHILD
>>>>> dependency pattern increases.
>>>> I'm... not entirely happy with such a solution ;(
>>>>
>>>> there must be a better one.
>>> 	We're trying to find it.  I really appreciate Louis taking the
>>> time to approach the issue.  His first pass was to add 1 to
>>> MUTEX_CHILD for each level of recursion.  This has a very tight limit
>>> (4 or 5 levels), but probably covers all users that exist and perhaps
>>> all that ever will exist.  However, it means passing the lockdep
>>> annotation level throughout the entire call chain across multiple
>>> files.  It was definitely less readable.
>>> 	This approach takes a different tack - it's very readable, but
>>> it assumes that the currently correct locking will always remain so -
>>> a particular invariant that lockdep exists to verify :-)
>>> 	Louis, what about sticking the recursion level on
>>> configfs_dirent?  That is, you could add sd->s_level and then use it
>>> when needed.  THis would hopefully avoid having to pass the level as
>>> an argument to every function.  Then we can go back to your original
>>> scheme.  If they recurse too much and hit the lockdep limit, just
>>> rewind everything and return -ELOOP.
>> you can also make a new lockdep key for each level... not pretty but it
>> works
> 
> Yeah, that is what I've done in the past for trees:
> 
> http://programming.kicks-ass.net/kernel-patches/concurrent-pagecache/23-rc1-rt/radix-concurrent-lockdep.patch

Thanks for pointing this out.

Yes this could solve part of the issue, at the price of duplicating the
inode mutex class. However, this still does not solve the issue when
deleting config_groups, since in that case all nodes of the tree are
locked. Thinking about adding lockdep support for concurrent locking of
the direct children of a node in a tree...

Louis

- --
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFIM/ifVKcRuvQ9Q1QRAmahAJ9n07/o3pgOteOgRnMR9a0iGDEFWQCgurOH
9MZ5E9iytPgn/v7QAxDTFrM=
=Q+7A
-----END PGP SIGNATURE-----
