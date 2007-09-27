Return-Path: <linux-kernel-owner+w=401wt.eu-S1753046AbXI0Cxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046AbXI0Cxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 22:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751457AbXI0Cxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 22:53:33 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:55643 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751135AbXI0Cxc (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 22:53:32 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: mgross@linux.intel.com
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] QoS params patch
In-Reply-To: Your message of "Wed, 26 Sep 2007 17:40:20 PDT."
             <20070927004020.GB29906@linux.intel.com>
From: Valdis.Kletnieks@vt.edu
References: <20070926223712.GA22029@linux.intel.com> <20070926224026.GA23218@linux.intel.com> <20070926164159.3b43479b.randy.dunlap@oracle.com>
            <20070927004020.GB29906@linux.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1190861583_20625P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 26 Sep 2007 22:53:03 -0400
Message-ID: <22087.1190861583@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1190861583_20625P
Content-Type: text/plain; charset=us-ascii

On Wed, 26 Sep 2007 17:40:20 PDT, Mark Gross said:
(others here are probably better at spotting leaks and races than I am,
so I'm skipping those and picking other nits. ;)

> --- linux-2.6.23-rc8/kernel/Makefile	2007-09-26 13:54:54.000000000 -0700
> +++ linux-2.6.23-rc8-qos/kernel/Makefile	2007-09-26 14:06:38.000000000 -
0700
> @@ -9,7 +9,7 @@
>  	    rcupdate.o extable.o params.o posix-timers.o \
>  	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
>  	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o die_notifier.o \
> -	    utsname.o
> +	    utsname.o qos_params.o

So I don't get a choice in the matter if I will be dragging this thing
around in my kernel, even if I have no intention of using the functionality?

> + * This QoS design is best effort based.  Dependents register their QoS needs.
> + * Watchers register to keep track of the current QoS needs of the system.
> + *
> + * There are 3 basic classes of QoS parameter: latency, timeout, throughput
> + * each have defined units:
> + * latency: usec
> + * timeout: usec <-- currently not used.
> + * throughput: kbs (kilo byte / sec)

It's unclear whether these are registering a differing QoS request for each
process/container/whatever that asks for one, or if they're global across the
system.  Also, even though it's "best effort", it would be good to document
what the failure mode is if we get conflicting requests, or an overcommit
situation - do new requests get refused, or allowed and ignored, or allowed
and only sometimes fulfilled.  For instance, assume a gigabit ethernet,
and 3 processes ask for 400 mbits/sec each - who wins, who gets part of what
they asked for, and who loses and gets starved?

> + * User mode requirements on a QOS parameter register themselves to the
> + * subsystem by opening the device node /dev/... and writing there request to
> + * the node.  As long as the process holds a file handle open to the node the

/dev?  What /dev entry do you use for a network interface?  Should this
be a configfs creature instead, or maybe something else?

> +/* static helper functions */
> +static s32 max_compare(s32 v1, s32 v2)

Blech.  Is it time for the yearly stamp-out-reinvention-of-max() already?
The use of pointer functions is interesting, but I have to wonder if there's
not a better way...

> +#define PID_NAME_LEN sizeof("process_1234567890")
> +static char name[PID_NAME_LEN];

And then you just pass a pointer to this and kstrdup() it.  Why not kmalloc()
the space initially and just 'dep->name = name;' and be done with it?

General nit - why qos_power_*, when none of the supported QoS parameters
seem to be power-related?

--==_Exmh_1190861583_20625P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFG+xsPcC3lWbTT17ARAm99AKCI9ho8QW3aS3is+4yl5EBqk6XUOQCg938b
C4qS3b6jAm1mE95snX8ANVQ=
=JNhG
-----END PGP SIGNATURE-----

--==_Exmh_1190861583_20625P--
