Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbXLFWSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbXLFWSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752511AbXLFWSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:18:39 -0500
Received: from lec.cs.unibo.it ([130.136.1.103]:58492 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149AbXLFWSi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:18:38 -0500
Date: Thu, 6 Dec 2007 23:18:37 +0100
To: Andi Kleen <andi@firstfloor.org>
Cc: Chris Friesen <cfriesen@nortel.com>, linux-kernel@vger.kernel.org
Subject: Re: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071206221837.GE30293@cs.unibo.it>
References: <20071205164055.GA2082@cs.unibo.it> <p73bq94k8yd.fsf@bingen.suse.de> <20071206053016.GA1464@cs.unibo.it> <20071206163538.GC20595@one.firstfloor.org> <47585D66.3000404@nortel.com> <20071206212644.GA26725@one.firstfloor.org> <47586E7F.1020903@nortel.com> <20071206220754.GF20595@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071206220754.GF20595@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some more explanations trying to describe what IPN is and what it is
useful for.  We are writing the complete patch....

Summary:
* IPN is for inter-process communication. It is *not* directly related 
to TCP-IP or Ethernet.
* IPN itself is a *level 1* virtual physical network.  IPN services
* (like AF_UNIX) do not require root privileges.  TAP and GRAB are just
* extra features for for IPN deliverying Ethernet frames.
----

* IPN is for inter-process communication. It is *not* directly related 
to TCP-IP or Ethernet.

If you want you can call it Inter Process Bus Communication.  It is an
extension of AF_UNIX.  Comments saying that some services can be
implemented by using TCP-IP multicast protocols are unrelated to IPN.
All AF_UNIX services could be implemented as TCP-IP services on
127.0.0.1. Do we abolish AF_UNIX, then?  The problem is that to use
TCP-IP, you'd need to wrap the packets with TCP or UDP, IP and Ethernet
headers, the stack would lose time to manage useless protocols.  If you
want just to send strings to set of local processes TCP-IP is an
overloading solution.  Even X-Window uses AF_UNIX sockets to talk with
local clients, it is a performance issue... I think Chris is right.

* IPN itself is a *level 1* virtual physical network.

Like any physical network you can run higher level protocols on it, thus
Ethernet, and then TCP-IP can be services you can run on IPN, but there
can be IPN networks running neither TCP-IP nor Ethernet.

* IPN services (like AF_UNIX) do not require root privileges.

There are many communication services where the user need broadcast or
p2p among user processes.  If a user (not root) wants to run several
User-Mode Linux, Qemu, Kvm VM the only way to have them connected
together is our Virtual Distributed Ethernet.  (For this reason VDE
exists in almost all the distros, it has been ported to other OSs, and
is already supported in the Linux Kernel for User-Mode Linux).  VDE is a
userland deamon, hence requires two context switches to deliver a
packet: VM1 -> K -> Daemon -> K -> VM2. Kvde running on IPN just one:
VM1 -> K ->VM2.  I think D-Bus can use IPN, too. The same cutoff of
context switches applies.  May I speculate that there will be a sensible
increase in performance?  *nix are multiuser. It means that there do
exist people that need to set up services without root access.  And even
if you have root access, the less you need to work as root, the safer is
you system.

* TAP and GRAB are just extra features for for IPN deliverying Ethernet frames.

Some IPN networks do use Ethernet as Data-Link protocol.  It is useful
to provide means to connect the IPN socket to a virtual (TAP) interface
or to a real (GRAB) interface.  I know that a lot of people use tap
interfaces, and the kernel bridge to connect Virtual Machines.  The
access can be resticted to some users or processes by itpables, but it
not as simple as a chmod to the socket.  A lot of people also use tunctl
to define a priori tap interfaces for users.  They must define as many
tuntap interfaces as the number of VM the users may want, each user has
his/her own taps.  Some users define a userland VDE switch to
interconnect their VM.  IPN itself could use a userland process to
define a standard TAP interface and loose its time and its cpu cycles to
move packets from tap to ipn and viceversa.  IPN is already kernel code
and then all its context switches and cpu cycles can be saved by
accessing the tap or grabbed interface diretly from the kernel.  (TAP
and GRAB obviously require CAP_NET_ADMIN).  Using IPN with TAP you can
define one single TAP interface connected to an IPN socket. Several VMs
can use that IPN socket, in this way the VMs are connected by a (virtual
ethernet) network which include the TAP interface.  The access control
to the network (and then to the TAP) is done by setting the permissions
to the socket.  Tunctl is *not* able to create a tap where all the users
belonging to a group can start their VM. IPN can.
