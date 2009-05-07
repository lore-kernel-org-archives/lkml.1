Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbZEGXSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbZEGXSu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 19:18:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZEGXSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 19:18:40 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47498 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZEGXSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 19:18:39 -0400
Date: Thu, 7 May 2009 16:18:44 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Eric Paris <eparis@parisplace.org>, Christoph Hellwig <hch@lst.de>,
       Andrew Morton <akpm@osdl.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       serue@us.ibm.com, hpa@zytor.com, sukadev@us.ibm.com,
       linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single and
	multiple-instancemounts
Message-ID: <20090507231844.GA27609@linux.vnet.ibm.com>
References: <20090307180816.GA30072@us.ibm.com> <20090307181232.GF30072@us.ibm.com> <7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com> <20090507212429.GA24064@linux.vnet.ibm.com> <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris [eparis@redhat.com] wrote:
| On Thu, 2009-05-07 at 14:24 -0700, Sukadev Bhattiprolu wrote: 
| > Eric Paris [eparis@parisplace.org] wrote:
| > | On Sat, Mar 7, 2009 at 2:12 PM, Sukadev Bhattiprolu
| > | <sukadev@linux.vnet.ibm.com> wrote:
| > | >
| > | > From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| > | > Subject: [v3][PATCH 5/5] Merge code for single and multiple-instance mounts
| > | 
| > | I just tried to load the linux-next kernel on F11 and ran into a
| > | problem.  X started, I could log in, I could start programs like
| > | firefox and evolution, but not gnome-terminal.  It would just flash
| > | and disappear.  Running xterm resulted in a window, that I could type
| > | in, but it wasn't a shell.  It didn't do anything.
| > | 
| > | I switched to vt2 set the display to my X session and tried to run
| > | xterm.  It said something about a permission being denied, so I
| > | decided to strace it.  I saw EACCESS returning from calls dealing with
| > | /dev/pts/0.  This lead me to git bisect start fs/devpts from the
| > | latest in linux-next as bad and 2.6.29 as good.  Couple interations
| > | later and I find that this commit (1bd7903560f1f7) breaks
| > | gnome-terminal xterm!
| > 
| > Interesting :-) -EACCESS makes me suspect that maybe 'mode' 'uid' or 'gid'
| > mount options are wrong. Of course we would still need to understand if/
| > why this patch changes the settings.
| > 
| > Can you paste the output of following commands: (both in success and failure
| > cases).
| > 
| > 	$ grep devpts /proc/mounts
| 
| Success: devpts /dev/pts devpts rw,relatime,mode=600,ptmxmode=000 0 0
| Failure: devpts /dev/pts devpts rw,seclabel,relatime,mode=000,ptmxmode=000 0 0
| 
| > 	$ ls -al /dev/pts
| Success:
| [root@dhcp231-142 ~]# ls -al /dev/pts
| total 0
| drwxr-xr-x.  2 root  root       0 2009-05-07 16:04 .
| drwxr-xr-x. 20 root  root    5300 2009-05-07 18:13 ..
| crw--w----.  1 paris paris 136, 0 2009-05-07 18:17 0
| crw--w----.  1 paris paris 136, 1 2009-05-07 16:07 1
| crw--w----.  1 paris paris 136, 2 2009-05-07 18:13 2
| crw--w----.  1 paris paris 136, 3 2009-05-07 18:17 3
| c---------.  1 root  root    5, 2 2009-05-07 16:04 ptmx 
| 
| Failure:
| [root@dhcp231-142 ~]# ls -al /dev/pts
| total 0
| drwxr-xr-x.  2 root  root       0 2009-05-07 18:22 .
| drwxr-xr-x. 20 root  root    5460 2009-05-07 18:28 ..
| c---------.  1 root  root    5, 2 2009-05-07 18:22 ptmx
| 
| > 	$ stat /dev/ptmx
| 
| 
| Failure:
|   File: `/dev/ptmx'
|   Size: 0               Blocks: 0          IO Block: 4096   character special file
| Device: eh/14d  Inode: 704         Links: 1     Device type: 5,2
| Access: (0666/crw-rw-rw-)  Uid: (    0/    root)   Gid: (    5/     tty)
| Access: 2009-05-07 18:23:20.695621624 -0400
| Modify: 2009-05-07 18:22:25.460004885 -0400
| Change: 2009-05-07 18:22:31.911129737 -0400
| 
| > 
| > Also, is CONFIG_DEVPTS_MULTIPLE_INSTANCES set in your .config ?
| 
| CONFIG_DEVPTS_MULTIPLE_INSTANCES=y
| 
| > With this patch, does gnome-terminal run when logged in as root ?
| 
| gnome-terminal did not, but xterm did appear in my window as root.  I
| assumed it was just some gnomism to not let me launch a root
| gnome-terminal inside the user owned X session.
| 
| 
| I unmounted /dev/pts and remounted it with mode=600 and it works now!
| 
| So something about this patch caused it to change from being mounted 600
| to 000.....

Must be the

	memset(&opts, 0, sizeof(opts));

in devpts_get_sb() (first statement). It should probably set the options to
default values for cases where 'data' is NULL.

For now, can you try replacing the memset with:

        opts->mode    = DEVPTS_DEFAULT_MODE;
        opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;

Sukadev
