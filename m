Return-Path: <linux-kernel-owner+w=401wt.eu-S1757489AbYEDOkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489AbYEDOkn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 10:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYEDOke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 10:40:34 -0400
Received: from barikada.upol.cz ([158.194.242.200]:60885 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYEDOkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 10:40:32 -0400
Date: Sun, 4 May 2008 17:01:30 +0200
To: David Collier-Brown <davecb@sun.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Roman Zippel <zippel@linux-m68k.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: kconfig - a suggestion how to fix the select issue
Message-ID: <20080504150130.GB24008@flower.upol.cz>
References: <20080504071041.GA15315@uranus.ravnborg.org> <481DB230.30907@sun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <481DB230.30907@sun.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Collier-Brown @ Sun, May 04, 2008 at 08:55:12AM -0400:
[]
> I speculate that having two ways to express a dependency,
> and the addtition of visibility control makes the
> dependency tree-walk into a problem which is no longer
> solvable in trivial logic. That in turn makes my head
> explode (;-))

In short:
mixing all together and applying resolving and UI heuristics on top.

> I wonder if one could simplify back into a flat set of
> selections without visibility rules and a backwards-
> chaining "you need to select these too" message emitter,
> and if that would be worthwhile.

No need to hide anything and invent complexity. Flexible and
human-friendly interface. (Batch things like def_condig are done by
humans, randconfig -- useless if there's no heuristics, allyes - simple.)

Just UI part for now. Automation of selection can be applied only, after
one can see whole picture. Say, you have [ UCcamers ] which depends on
USB, Video, etc.

+-- Navigation ---------------------------------------------------+
|  ...            [ arch     ]      [ atm ]     [ w-less speaker] |
|  [ kernel ] --> [ drivers  ]  --> [ fun ] --> [ camerass      ] |
|  [ klibc  ]     [ file sys ]      [ mtd ]     [ manual DMA    ] |
|  ...            ...               ...         ...               |
+-----------------------------------------------------------------+
+--     needs     ------+  +-- configure -----+  +--  options  ---+
| ++Universal S bus++++ |  |  ...             |  | build: y [m] n |
| --Video capture---    |<-+-[* UCcamera    ]-+->| RGB support y  |
| --sysfs kernel for u- |  |  * LPTcamera     |  | YUV support y  |
|                       |  |  * RS232camera   |  | HSB support y  |
+-----------------------+  +------------------+  +----------------+
+-- command line/text editor -- olecom@kit[configure] ------------+
$ build = m \n
$ go <

+--  walk tags  ---------+ +------------- Description ------------+
| intro, kernel, drivers,| | USB camera with foo bar features     |
| fun, [camerass]        | | with dual-core toaster and coffee    |
|                        | | machine inside                       |
|                        | |                                      |
|                        | | Options:                             |
|                        | | * RGB enables RGB                    |
|                        | | ....                                 |
+------------------------+ +--------------------------------------+

So, after 'go <' command (visually or command-lineually) we will be in
[--Video capture--] which isn't configured/enabled yet (due to --)

Now,

+-- Navigation ---------------------------------------------------+
|  ...            [ arch     ]      [ atm ]     [ w-less speaker] |
|  [ kernel ] --> [ drivers  ]  --> [*fun*] --> [ camerass      ] |
|  [ klibc  ]     [ file sys ]      [ mtd ]     [ manual DMA    ] |
|  ...            ...               ...         ...               |
+-----------------------------------------------------------------+
+--     needs     ------+  +-- configure -----+  +--  options  ---+
| ++Universal S bus++++ |  |  ...             |  | build: y [m] n |
| [-Video capture--]    |<-+-[* UCcamera    ]-+->| RGB support y  |
| --sysfs kernel for u- |  |  * LPTcamera     |  | YUV support y  |
|                       |  |  * RS232camera   |  | HSB support y  |
+-----------------------+  +------------------+  +----------------+
+-- command line/text editor -- olecom@kit[ needs   ] ------------+
$ build = m \n
$ go < \n
$ we are here, hitting enter on needs/video
+--  walk tags  ---------+ +------------- Description ------------+
| intro, kernel, drivers,| | Video processing for everyone        |
| fun, cameras, [videoP] | | all is supported all works with no   |
|                        | | OOP and shaman drums                 |
|                        | |                                      |
|                        | | Inside MMA:                          |
|                        | | * conf: DEBUG                        |
|                        | | * build: chip1...                    |
+------------------------+ +--------------------------------------+

we will have:

+-- Navigation ---------------------------------------------------+
|  [ arch     ]    [ mtd   ]    [ radio ]    [ bt8xx    ]         |
|  [ drivers  ] -> [ media ] -> [*video*] -> [ cpia2    ]         |
|  [ file sys ]    [ ps3   ]    [ common]    [ usbvideo ]         |
|  ...            ...               ...         ...               |
+-----------------------------------------------------------------+
+--     needs     ------+  +-- configure -----+  +--  options  ---+
| --V4L1--              |  |  ...             |  | menu:          |
| --V4L2--              |<-+-[*Video capture]-+->| * DEBUG_FOO    |
| --V4W7--              |  |  * Video decode  |  | * bt8xx        |
|                       |  |  * Video improve |  | ...            |
+-----------------------+  +------------------+  +----------------+
+-- command line/text editor -- olecom@kit[configure] ------------+
$ go < \n
$ we are here, hitting enter on needs/video
$
+--  walk tags  ---------+ +------------- Description ------------+
| intro, kernel, drivers,| | Video processing for everyone        |
| fun, cameras, [video]  | | all is supported all works with no   |
|                        | | OOP and shaman drums                 |
|                        | |                                      |
|                        | | Inside MMA:                          |
|                        | | * this is menu                       |
|                        | |                                      |
+------------------------+ +--------------------------------------+

== [ rant ] ==

Can some of those PS3 or KDE teams design proper "Konfigure Linux"
game for kernel hackers? I try to do this with TERM=linux, `sh`, and
`sed`. Patching paper work isn't for such tasks.

On collecting CONFIG_ info by gcc in sources, thus generating symbol
dependency automatically, was told to shut up. Let's see what will
happen next. Don't forget to use cultural skills, imagination and
creativity.
--
sed 'sed && sh + olecom = love' << ''
-o--=O`C
 #oo'L O
<___=E M
