Return-Path: <linux-kernel-owner+w=401wt.eu-S1756282AbZADWnB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756282AbZADWnB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 17:43:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbZADWmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 17:42:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49537 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZADWmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 17:42:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [Regression] Build failure in current mainline - firmware related
Date: Sun, 4 Jan 2009 23:43:13 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
References: <200901031247.14977.rjw@sisk.pl> <200901032243.28684.rjw@sisk.pl> <20090104214406.GA31668@uranus.ravnborg.org>
In-Reply-To: <20090104214406.GA31668@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042343.13494.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009, Sam Ravnborg wrote:
> On Sat, Jan 03, 2009 at 10:43:28PM +0100, Rafael J. Wysocki wrote:
> > On Saturday 03 January 2009, Sam Ravnborg wrote:
> > > On Sat, Jan 03, 2009 at 09:49:48PM +0100, Sam Ravnborg wrote:
> > > > On Sat, Jan 03, 2009 at 12:47:14PM +0100, Rafael J. Wysocki wrote:
> > > > > Hi,
> > > > > 
> > > > > I get the following error from 'make modules_install' on my test boxes:
> > > > > 
> > > > >   HOSTCC  firmware/ihex2fw                                                             
> > > > > /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system                                            
> > > > > compilation terminated.                                                                
> > > > > make[3]: *** [firmware/ihex2fw] Error 1                                                
> > > > > make[2]: *** [_modinst_post] Error 2                                                   
> > > > > make[1]: *** [sub-make] Error 2                                                        
> > > > > make: *** [all] Error 2
> > > > > 
> > > > > where the configuration is that the kernel is compiled on a build box
> > > > > with 'make O=<destdir> -j5' and then <destdir> is mounted over NFS read-only by
> > > > > each test box (full path to this directory is the same on the build box and on
> > > > > the test boxes).  Then, I cd into <destdir>, run 'make modules_install' and get
> > > > > the error above.
> > > > > 
> > > > > 2.6.28 didn't have this problem.
> > > > 
> > > > 
> > > > Strange...
> > > > 1) The string "opening dependency file" does not occur in my freshly pulled kernel
> > > > 2) Line 268 is last line of ihex2fw.c
> > > > 
> > > > Could you try to do a "make modules_install V=1" to see the exact arguments supplied ti ihex2fw.c
> > > > 
> > > > I gave up on all the firmware stuff long time ago and has
> > > > never properly reviewed the implementation so I really
> > > > have no clue what is actually happening.
> > > > 
> > > > Walking through the 179 lines Makefile has not yet benn on my
> > > > "fun to do" list - and it most likely take a while before it hits it.
> > > 
> > > Took a quick peek. The Makefile uses "order only" in three spots.
> > > This alone demand make version 3.80 IIRC and Documetnation/Changes
> > > says 3.79.1...
> > > 
> > > The "order only" is so rare that Paul Smith once said that
> > > coming up with a good example of usage was not easy.
> > > 
> > > For the headers_* stuff I recall when I reworked it I could
> > > kill the usage of "order only" there but now it crept
> > > back - sigh!
> > 
> > Well, in the meantime I ran 'make modules_install V=1' and this is the
> > last thing printed (the previous ones are not really interesting):
> > 
> > make -f /home/rafael/src/linux-2.6/scripts/Makefile.fwinst obj=firmware __fw_modinst
> >   gcc -Wp,-MD,firmware/.ihex2fw.d -Ifirmware -Wall -Wstrict-prototypes -O2 -fomit-frame-pointer -o firmware/ihex2fw /home/rafael/src/linux-2.6/firmware/ihex2fw.c
> > /home/rafael/src/linux-2.6/firmware/ihex2fw.c:268: fatal error: opening dependency file firmware/.ihex2fw.d: Read-only file system
> > compilation terminated.
> > make[3]: *** [firmware/ihex2fw] Error 1
> > make[2]: *** [_modinst_post] Error 2
> > make[1]: *** [sub-make] Error 2
> > make: *** [all] Error 2
> > 
> > It fails because of the attempt to compile ihex2fw .
> 
> There are at least two obvious ways to fix this.
> 
> We could try to rearrange things so we do not trigger
> the rebuild of ihex2fw in the modules_install case.
> This would likely involve creating a new file listing
> all the firmawre files and share it between firmware/Makefile
> and scripts/Makefile.fwinst
> 
> We could also move ihex2fw to scripts so it is build
> as part of the preparation for a kernel build.
> 
> Attched patch does the latter.
> [I will update the changelog before I eventually commit it].

The patch helps, thanks a lot.

Best,
Rafael
