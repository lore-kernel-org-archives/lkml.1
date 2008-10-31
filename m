Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYJaBj5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYJaBj5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 21:39:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYJaBjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 21:39:48 -0400
Received: from moat.camk.edu.pl ([148.81.175.50]:47225 "EHLO moat.camk.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753098AbYJaBjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 21:39:47 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Oct 2008 21:39:47 EDT
Date: Fri, 31 Oct 2008 02:30:21 +0100 (CET)
From: Aleksander Schwarzenberg-Czerny <alex@camk.edu.pl>
To: linux-kernel@vger.kernel.org
Subject: bugs in acroread and firefox combined 
Message-ID: <alpine.LFD.2.00.0810310221190.9998@gatekeeper.camk.edu.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

==========TITLE====================
opening and closing pdf from firefox leaves acroread eating memory till 
full
==========SUMMARY====================
firefox after opening pdf and closing
document leaves acrobatreader running wild and eating
memory till system grinds to stop. It seems that two separate
bugs, memory leak in acrobat reader (courtsey to Adobe)
and its wrong call by firefox may combine to
produce this effect. They are described below separately.


==============THE BUG IN ADOBEREADER (i.e.not in FC8)
This bug is demonstrated by opening and closing the same document
while acroread is continuously running as stand alone program.
It may be connected with the word search function-no proof yet.
The effect is expansion of the memory occupied by acroread after
each cycle of actions. Without user action spontaneous memory loss does 
not occure. I do not think it depends on the type of .pdf document.
I was using http://arxiv.org/abs/0808.2937 and other pdf documents
from this free bibliographic database, as well as documents compiled
with kile on my own computer.

Example:
......
AdobeReader started as stand-alone program and document opened,

>top
...
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  7767 root      20   0  113m  25m 8428 S    2  5.0   8:46.77 X
  2568 root      20   0  3396  444  364 S    1  0.1   2:50.98 
hald-addon-stor
  8041 alex      20   0  2272 1016  784 R    1  0.2   0:38.98 top
12364 alex      20   0  131m  47m  30m S    1  9.4   0:11.23 acroread
   387 root      15  -5     0    0    0 S    0  0.0   0:57.92 scsi_eh_1

... document closed, opened again, word search performed, closed
while AdobeReader still running, whole cycle repeated several times

>top
...
   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
  7767 root      20   0  109m  21m 8608 S    2  4.2   9:26.22 X
  8008 alex      20   0  103m  20m  12m S    2  4.1   0:40.65 
gnome-terminal
12364 alex      20   0  132m  49m  30m S    1  9.9   0:41.57 acroread
12418 alex      20   0  2272 1016  784 R    1  0.2   0:02.03 top
   387 root      15  -5     0    0    0 S    0  0.0   0:58.39 scsi_eh_1

%MEM occupied increased (on rare occasions it decreases by 0.1, but 
tendency is to increase after each action. However, no memory is eaten
spontaneously. For longer documents the memory increase seems in bigger 
increments. This behaviour may indicate a memory leak in acroread code.

After stopping acroread from the program menu, acroread disappears
from the list of running tasks produced by top, as expected.

=======================THE BUG IN FIREFOX CALL OF ACROREAD ==============
This bug was already decribed in www by more competent experts.
It seems that firefox does not stop acroread properly.

Roughly, when you open acroread from firefox to view  a pdf document,
and then close it, the acroread is left running and eats memory on its 
own.
It does not stop after quitting firefox. I have seen opinions on www that
it is accompanied by repeated attempts of acroread to contact X windows.
If true, at each attempt it could trigger the afore-mentioned
bug in acroread itself and cause memory leak at each cycle.

Notebly, when acroread is called from firefox, the word search function 
does
not work: no text is accepted in the template word window. This may or may 
not
have to do with the aforementioned bug.

I hope this may help to solve this bugs.
Alex Schwarzenberg-Czerny
============KEYWORDS======================
acroread,adobereader,firefox,memory full,system crash

============KERNEL VERSION=================
[alex@localhost ~]$ more /proc/version
Linux version 2.6.26.6-49.fc8 (mockbuild@x86-2.fedora.phx.redhat.com) (gcc 
versi
on 4.1.2 20070925 (Red Hat 4.1.2-33)) #1 SMP Fri Oct 17 15:59:36 EDT 2008

==========ENVIRONMENT======================

processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 3
cpu MHz         : 801.830
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca 
cmov pat
pse36 mmx fxsr sse
bogomips        : 1603.37
clflush size    : 32
power management:

X Window System Version 1.3.0
Release Date: 19 April 2007
X Protocol Version 11, Revision 0, Release 1.3
Build Operating System: Fedora 8 Red Hat, Inc.
Current Operating System: Linux localhost.localdomain 2.6.26.6-49.fc8 #1 
SMP Fri Oct 17 15:59:36 EDT 2008 i686
Build Date: 24 July 2008
Build ID: xorg-x11-server 1.3.0.0-47.fc8


AdobeReader 8
Version 8.1.2 06/21/2008
yum list AdobeReader_enu
Installed Packages
AdobeReader_enu.i486                     8.1.2_SU1-1            installed

After last firefox upgrade, I have reinstalled acrobat reader.




