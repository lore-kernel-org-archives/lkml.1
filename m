Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZI3ISc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZI3ISc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 04:18:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754050AbZI3ISb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 04:18:31 -0400
Received: from mx01.bfk.de ([193.227.124.2]:50312 "EHLO mx01.bfk.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153AbZI3IS3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 04:18:29 -0400
To: Jamie Lokier <jamie@shareable.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Valdis.Kletnieks@vt.edu,
       linux@treblig.org, agruen@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
References: <E1Mqpfq-0003uZ-Pw@pomaz-ex.szeredi.hu>
	<200909250223.58664.agruen@suse.de>
	<E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
	<20090925123747.GA31228@gallifrey>
	<9988.1253899252@turing-police.cc.vt.edu>
	<20090925183523.GA6065@gallifrey>
	<19645.1253913514@turing-police.cc.vt.edu>
	<E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu>
	<20090928132845.GC19778@shareable.org>
From: Florian Weimer <fweimer@bfk.de>
Date: Wed, 30 Sep 2009 08:18:21 +0000
In-Reply-To: <20090928132845.GC19778@shareable.org> (Jamie Lokier's message of "Mon\, 28 Sep 2009 14\:28\:45 +0100")
Message-ID: <82d4589776.fsf@mid.bfk.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jamie Lokier:

> I hope the above cannot convert O_NOACCESS to O_RDWR without checking
> that you have access to the file.

It doesn't.

Here's what I did to reproduce:

$ mkdir /tmp/xyz
$ touch /tmp/xyz/123
$ tail -f /tmp/xyz/123

And in another terminal:

$ chmod 000 /tmp/xyz
$ echo foo > /tmp/xyz/123
bash: /tmp/xyz/123: Permission denied
$ $ echo foo > /proc/$pid_of_tail/fd/5

And the first terminal prints "foo".  It fails if the file it self is
not writeable, only the access check on the path is bypassed.  I still
think this is wrong.

FWIW, fcntl(F_SETFL) is documented to ignore O_RDWR etc. flags.  For
/proc/PID/fd, it probably makes sense to check the current access
flags on the object, and the original open mode.  Rechecking the path
seems impossible because it has unclear semantics.

The whole thing is a bit worrisome because it may turn file descriptor
information leaks into something worse.

-- 
Florian Weimer                <fweimer@bfk.de>
BFK edv-consulting GmbH       http://www.bfk.de/
Kriegsstraﬂe 100              tel: +49-721-96201-1
D-76133 Karlsruhe             fax: +49-721-96201-99
