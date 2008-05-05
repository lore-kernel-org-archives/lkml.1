Return-Path: <linux-kernel-owner+w=401wt.eu-S1757418AbYEEHDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757418AbYEEHDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbYEEHC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:02:57 -0400
Received: from 1wt.eu ([62.212.114.60]:4105 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992AbYEEHC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:02:57 -0400
Date: Mon, 5 May 2008 09:02:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount point inside a read only filesystem
Message-ID: <20080505070214.GA14635@1wt.eu>
References: <18456.34604.472989.35082@ipc1.ka-ro> <20080501215231.297e0d9d.akpm@linux-foundation.org> <53722.192.168.1.70.1209711343.squirrel@neil.brown.name> <20080503063231.GA688@1wt.eu> <18462.43245.728465.911831@ipc1.ka-ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <18462.43245.728465.911831@ipc1.ka-ro>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 08:27:57AM +0200, Lothar Waßmann wrote:
> I'm using busybox 1.0 (on an embedded PXA320 system).

OK

> > stat64("/dev/a/b/c", 0xbf9175dc)        = -1 ENOENT (No such file or directory)
> > umask(0)                                = 022
> > open(".", O_RDONLY|O_LARGEFILE|O_DIRECTORY) = 3
> > chdir("/")                              = 0
> > mkdir("dev", 0755)                      = -1 EEXIST (File exists)
> > stat64("dev", {st_mode=S_IFDIR|0755, st_size=17080, ...}) = 0
> > chdir("dev")                            = 0
> > mkdir("a", 0755)                        = 0
> > chdir("a")                              = 0
> > mkdir("b", 0755)                        = 0
> > chdir("b")                              = 0
> > umask(022)                              = 0
> > mkdir("c", 0777)                        = 0
> > fchdir(3)                               = 0
> > close(3)                                = 0
> > 
> This is what strace shows in my case:
> mkdir("/", 0777)                        = -1 EEXIST (File exists)
> stat64("/", {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
> mkdir("/dev/", 0777)                    = -1 EROFS (Read-only file system)
> umask(022)                              = 022
> write(2, "mkdir: ", 7mkdir: )                  = 7
> write(2, "Cannot create directory `/dev/\'", 31Cannot create directory `/dev/') = 31
> write(2, ": Read-only file system\n", 24: Read-only file system
> ) = 24
> io_submit(0x1, 0x1, 0xfbad2088 <unfinished ... exit status 1>

So you should send this trace to the busybox maintainer. It
obviously exhibits a small but easily fixable bug in the
program ; it should check whether the directory exists in
case of error. It seems it only checks for EEXIST.

What puzzles me is why you have this problem only with a new kernel.
I suspect that previous ones did report EEXIST and now we report
EROFS for an existing directory on an ro fs.

Willy

