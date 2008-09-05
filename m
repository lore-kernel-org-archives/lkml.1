Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYIEPbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYIEPbu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 11:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753569AbYIEPbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 11:31:41 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:36851 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbYIEPbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 11:31:40 -0400
Date: Fri, 5 Sep 2008 10:31:34 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080905153134.GA18367@us.ibm.com>
References: <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu> <20080903220215.GA27705@us.ibm.com> <E1Kb0ml-0006qL-5M@pomaz-ex.szeredi.hu> <20080903224334.GA726@us.ibm.com> <E1Kb8Y0-0008Gh-FP@pomaz-ex.szeredi.hu> <20080904132804.GA14709@us.ibm.com> <E1KbFU3-0002Ne-Oe@pomaz-ex.szeredi.hu> <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KbGwb-0002rl-49@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Thu, 04 Sep 2008, Miklos Szeredi wrote:
> > On Thu, 4 Sep 2008, Serge E. Hallyn wrote:
> > > Are you going to revert the change forcing CL_SLAVE for
> > > !capable(CAP_SYS_ADMIN)?  I don't think we want that - I think that
> > > *within* a set of user mounts, propagation should be safe, right?
> > > 
> > > Will you be able to do this soon?  If not, should we just do the part
> > > returning -EPERM when turning a shared mount into a user mount? 
> > 
> > OK, let's do that first and the tricky part (propagation vs. user
> > mounts) later.  Will push after I've tested it.
> 
> Here it is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts
> 
> I don't know what's next, this patchset has been in and out of -mm for
> as long as I can remember, but it hasn't generated much interest
> outside the two of us :)
> 
> I do think this is an important feature though, even if not as sexy as
> some other things.
> 
> Al?  Is there any chance of this making it to 2.6.28?
> 
> Thanks,
> Miklos

Ok I should take the time to properly add these to ltp, but for now here
is the result of 15-minutes of playing around with shell scripts to do
some basic testing.

Run usermounts_root.sh as root first, then usermounts_user as a user.
Cleanup for the usermounts_root.sh side-effects is not done.

Miklos, do you have better-thought-out or more complete testcases?

-serge

=====================================================================
FILE usermounts_root.sh
=====================================================================
#!/bin/sh
MMOUNTDIR=/usr/src/mmount-0.3
MOUNT=${MMOUNTDIR}/mmount
UMOUNT=${MMOUNTIDR}/ummount

mkdir -p /mnt/shared /mnt/slave /mnt/private
mkdir /mnt/shared/d /mnt/slave/d /mnt/private/d

touch /mnt/shared/a
touch /mnt/slave/b
touch /mnt/private/c

mount --bind /mnt/shared /mnt/shared
mount --make-rshared /mnt/shared
mount --bind /mnt/shared /mnt/slave
mount --make-rslave /mnt/slave
=====================================================================


=====================================================================
FILE usermounts_user.sh
=====================================================================
#!/bin/sh
MMOUNTDIR=/usr/src/mmount-0.3
MOUNT=${MMOUNTDIR}/mmount
UMOUNT=${MMOUNTDIR}/ummount

mkdir t1

# user bind a root shared mount.  Should fail -EPERM.

$MOUNT --bind /mnt/shared t1
rc=$?
if [ $rc -eq 0 ]; then
	echo "FAIL: succeeded in user-binding a root-shared dir"
	exit 1
fi
echo "PASS: first test passed (refused to user-bind a root-shared dir"

# user bind a root shared mount, then bind into there.  Make sure
# that the two binds work, and the second is not propagated to the
# first

$MOUNT --bind /mnt/slave t1
$MOUNT --bind /mnt/private t1/d
if [ ! -f t1/d/c ]; then
	echo "failed mounting private under slave/d"
	exit 1
fi
if [ -f /mnt/slave/d/c ]; then
	echo "user mount of private under slave/d was propagated to /mnt/slave!"
	exit 1
fi
if [ -f /mnt/shared/d/c ]; then
	echo "user mount of private under slave/d was propagated to /mnt/shared!"
	exit 1
fi

ret=0
$UMOUNT t1/d || ret=1
$UMOUNT t1 || ret=1
if [ $ret -eq 1 ]; then
	echo "user umount refused in second test"
	exit 1
fi
if [ -f t1/a ]; then
	echo "user umount failed in second test"
	exit 1
fi

rmdir t1

echo "PASS: second test passed (user-mounts of root-slave and root-private dirs)"

# bind mount /etc/shadow.  First make sure that we cannot read
# /etc/shadow and can read the target.  Then make sure that we
# can no longer read the target after the bind mount.

cat /etc/shadow >> /dev/null
rc=$?
if [ $rc -eq 0 ]; then
	echo "test 3: Oh no, I'm able to read /etc/shadow!"
	exit 1
fi
echo ab > t1
cat t1 >> /dev/null
rc=$?
if [ $rc -ne 0 ]; then
	echo "test 3: Odd, couldn't read my own file."
	exit 1
fi
$MOUNT --bind /etc/shadow t1
cat t1 >> /dev/null
rc=$?
if [ $rc -eq 0 ]; then
	echo "test 3: bind mount of /etc/shadow gave me read access!"
	exit 1
fi
$UMOUNT t1
rm t1

echo "PASS: third test passed (user mount of file)"

echo "all tests succeeded"
exit 0
=====================================================================
