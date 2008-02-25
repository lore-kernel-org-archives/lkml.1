Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbYBYRMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbYBYRMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 12:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYBYRMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 12:12:10 -0500
Received: from mail.qconline.com ([204.176.110.250]:1220 "EHLO
	mail.qconline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbYBYRMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 12:12:08 -0500
X-Greylist: delayed 319 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Feb 2008 12:12:08 EST
X-Modus-BlackList: 64.4.171.82=OK;harrycoin@qconline.com=OK
X-Modus-RBL: 64.4.171.82=Excluded
X-Modus-Trusted: 64.4.171.82=NO
X-Modus-Audit: FALSE;0;0;0
Message-ID: <47C2F59A.1000505@qconline.com>
Date: Mon, 25 Feb 2008 11:06:34 -0600
From: Harry Coin <harrycoin@qconline.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: DumpHardwarestack <pid> [open filehandle,*] would be nice!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A little utility (needing supporting kernel system call) that took a 
process id as input then dumps to stdout the total hardware stack 
supporting every handle currently open to that process -- would be very 
nice.  If it already exists please let me know and forgive the newbie 
mistake.

Please consider a whether a new member of the family 
open/close/seek/read/write/ioctl is in order, whether its own call or a 
new systemwide ioctl. 

The main need is to provide a reliable way to know the 
make/model/serial#" of each element of the hardware stack supporting an 
open handle managed by local devices and drivers.  Seems all I can find 
are a pastiche of sporadically implemented IOCTL calls that vary 
depending on the nature of the device (e.g. try to get the serial number 
of an arbitrary USB device given an open handle, for instance) , or 
really code-maintenance uber-unfriendly invitations to recover and parse 
filename paths, cope with links, then rummage about in /proc /sys and dmesg.

So, something like:

handle = open("any file or device here",O_YourChoiceHere);
read_hardware_chain(handle,char *buffer,int buffersize);

Upon successful return "buffer" would contain one line for each bit of 
physical technology used to provide access to handle.

"Vendor-lowest 
level","Model-lowest-level","Serial-lowest-level","/sys/full-path-to-most-specific-info"\n

for example:  handle=open("USB device X",O_RDONLY);  
read_hardware_chain(handle,buffer,4096);
buffer gets set to:
"USB device vendor","Usb device model","usb device serial 
#","/sys/more/info/here"\n
"Usb controller vendor","USB model","l","/sys/more/info/here"\n
"PCI bus bridge chip vendor","bridge chip model","","/sys/more/info/here"\n
"Southbridge vendor","Southbridge model","serial","/sys/more/info/here"\n
"Northbridge vendor","Northbridge model","northbridge 
serial","/sys/more/info/here"\n
"Memory vendor","Memory model","Serial numbers of 
chips","/sys/more/info/here"\n
"Processor vendor","Processor model/stepping","CPUID if 
supported","/sys/more/info/here"\n
"distro name","kernel name","kernel versions","/sys/lotsaluck"\n
"Bios vendor","bios version","Bios serial","/sys/more/info/here"\n
"Overall system vendor","Overall system model","Overall system 
serial#/support id tag","/sys/no/joy"\n

2 motivations: 

Motivation 1:  You have many device X's out there attached to various 
boxen which come and go way more frequently than device X does, and all 
the X's reports to and are controlled by a database.  Each device X has 
its own serial number which is the only reasonable choice to provide 
access to X without making X management code have to know what host X is 
plugged into for net access from moment to moment.  You don't like the 
really hackish looking code that has to text munge around both /proc and 
/sys to try to tease out X's serial number, and having to examine every 
new kernel for formatting changes in both those structures in order to 
maintain X device support.  And you don't want to have every driver 
create its own non-standard internal IOCTL call number and format for 
reporting config details and a second one for 'here's the path to my 
parent device'.  And you certainly don't want production code trying to 
parse dmesg output messages looking for load time 'I found this 
model/serial/brand/withcool-blue-lights, mounted on /dev/zippyhummer, 
excelsior!' announcements.

Motivation2:  Support help.  Make more efficient the presently too 
frequent reporting exchange  "Accessing Foo is flaky when I do this" 
"send a dmesg output" "where is foo loaded, which plug did you 
use","Well, its a symbolic link that pointed to a CD yesterday but now 
which LVM RAID did that get mounted on?" or "which USB device number is 
that this boot - depends on whether the other cable was loose during the 
udev scan"  get a whole lot simpler.


Harry Coin
Quietfountain LLC
Bettendorf, Iowa




