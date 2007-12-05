Return-Path: <linux-kernel-owner+w=401wt.eu-S1754153AbXLERKy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbXLERKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 12:10:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLERKq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 12:10:46 -0500
Received: from lec.cs.unibo.it ([130.136.1.103]:53584 "EHLO lec.cs.unibo.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbXLERKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:10:45 -0500
X-Greylist: delayed 1788 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2007 12:10:44 EST
Date: Wed, 5 Dec 2007 17:40:55 +0100
To: linux-kernel@vger.kernel.org
Subject: New Address Family: Inter Process Networking (IPN)
Message-ID: <20071205164055.GA2082@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
From: renzo@cs.unibo.it (Renzo Davoli)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Inter Process Networking: 
a kernel module (and some simple kernel patches) to provide 
AF_IPN: a new address family for process networking, i.e. multipoint,
multicast/broadcast communication among processes (and networks).

WHAT IS IT?
-----------
Berkeley socket have been designed for client server or point to point
communication. All existing Address Families implement this idea.
IPN is a new address family designed for one-to-many, many-to-many and 
peer-to-peer communication among processes.
IPN is an Inter Process Communication paradigm where all the processes
appear as they were connected by a networking bus.
On IPN, processes can interoperate using real networking protocols 
(e.g. ethernet) but also using application defined protocols (maybe 
just sending ascii strings, video or audio frames, etc).
IPN provides networking (in the broaden definition you can imagine) to
the processes. Processes can be ethernet nodes, run their own TCP-IP stacks
if they like (e.g. virtual machines), mount ATAonEthernet disks, etc.etc.
IPN networks can be interconnected with real networks or IPN networks
running on different computers can interoperate (can be connected by
virtual cables).
IPN is part of the Virtual Square Project (vde, lwipv6, view-os, 
umview/kmview, see wiki.virtualsquare.org).

WHY?
----
Many applications can benefit from IPN.
First of all VDE (Virtual Distributed Ethernet): one service of IPN is a
kernel implementation of VDE.
IPN can be useful for applications where one or some processes feed their 
data to several consuming processes (maybe joining the stream at run time).
IPN sockets can be also connected to tap (tuntap) like interfaces or
to real interfaces (like "brctl addif").
There are specific ioctls to define a tap interface or grab an existing
one.
Several existing services could be implemented (and often could have extended
features) on the top of IPN:
- kernel bridge
- tuntap
- macvlan
IPN could be used (IMHO) to provide multicast services to processes.
Audio frames or video frames could be multiplexed such that multiple
applications can use them. I think that something like Jack can be
implemented on the top of IPN. Something like a VideoJack can
provide video frames to several applications: e.g. the same image from a
camera can be viewed by xawtv, recorded and sent to a streaming service.
IPN sockets can be used wherever there is the idea of broadcasting channel 
i.e. where processes can "join (and leave) the information flow" at
runtime. 
Different delivery policies can be defined as IPN protocols (loaded 
as submodules of ipn.ko).
e.g. ethernet switch is a policy (kvde_switch.ko: packets are unicast 
delivered if the MAC address is already in the switching hash table), 
we are designing an extendended switch, full of interesting features like
our userland vde_switch (with vlan/fst/manamement etc..), and a layer3
switch, but other policies can be defined to implement the specific
requirements of other services. I feel that there is no limits to creativity 
about multicast services for processes.
Userspace services (like vde or jack) do exist, but IPN provides
a faster and unified support.

HOW?
----
The complete specifications for IPN can be found here:
http://wiki.virtualsquare.org/index.php/IPN

bind() creates the socket (if it does not already exist). When bind() succeeds, 
the process has the right to manage the "network". 
No data is received or can be send if the socket is not connected 
(only get/setsockopt and ioctl work on bound unconnected sockets).

connect() is used to join the network. When the socket is connected it 
is possible to send/receive data. If the socket is already bound it is
useless to specify the socket again (you can use NULL, or specify the same
address).
connect() can be also used without bind(). In this case the process sends and
receives data but it cannot manage the network (in this case the socket
address specification is required).

listen() and accept() are for servers, thus they does not exist for IPN.

Examples:
1- Peer-to-Peer Communication:
Several processes run the same code:

  struct sockaddr_un sun={.sun_family=AF_IPN,.sun_path="/tmp/sockipn"};
  int s=socket(AF_IPN,SOCK_RAW,IPN_BROADCAST); 
  err=bind(s,(struct sockaddr *)&sun,sizeof(sun));
  err=connect(s,NULL,0);

In this case all the messages sent by each process get received by all the
other processes (IPN_BROADCAST). 
The processes need to be able to receive data when there are pending packets, 
e.g. by using poll/select and event driven programming or multithreading.

2- (One or) Some senders/many receivers
The sender runs the following code:

  struct sockaddr_un sun={.sun_family=AF_IPN,.sun_path="/tmp/sockipn"};
  int s=socket(AF_IPN,SOCK_RAW,IPN_BROADCAST);
  err=shutdown(s,SHUT_RD);
  err=bind(s,(struct sockaddr *)&sun,sizeof(sun));
  err=connect(s,NULL,0);

The receivers do not need to define the network, thus they skip the bind():

  struct sockaddr_un sun={.sun_family=AF_IPN,.sun_path="/tmp/sockipn"};
  int s=socket(AF_IPN,SOCK_RAW,IPN_BROADCAST); 
  err=shutdown(s,SHUT_WR);
  err=connect(s,(struct sockaddr *)&sun,sizeof(sun));

In the previous examples processes can send and receive every kind of
data. 

When messages are ethernet packets (maybe from virtual machines), IPN 
works like a Hub by using the IPN_BROADCAST protocol.
Different protocols (delivery policies) can be specified by changing 
IPN_BROADCAST with a different tag. 
A IPN protocol specific submodule must have been registered 
the protocol tag in advance. (e.g. when kvde_switch.ko is loaded 
IPN_VDESWITCH can be used too).
The basic broadcasting protocol IPN_BROADCAST is built-in (all the 
messages get delivered to all the connected processes but the sender). 

IPN sockets use the filesystem for naming and access control.
srwxr-xr-x 1 renzo renzo 0 2007-12-04 22:28 /tmp/sockipn
An IPN socket appear in the file like a UNIX socket.
r/w permissions represent the right to receive from/send data to the
socket. The 'x' permission represent the right to manage the socket.
connect() automatically shuts down SHUT_WR or SHUT_RD if the user has not
the correspondent right.

WHAT WE NEED FROM THE LINUX KERNEL COMMUNITY
--------------------------------------------
0- (Constructive) comments.

1- The "official" assignment of an Address Family.
(It is enough for everything but interface grabbing, see 2)

in include/linux/net.h:
- #define NPROTO          34              /* should be enough for now..  */
+ #define NPROTO          35              /* should be enough for now..  */

in include/linux/socket.h
+ #define AF_IPN 34
+ #define PF_IPN AF_IPN
- #define AF_MAX          34      /* For now.. */
+ #define AF_MAX          35      /* For now.. */

This seems to be quite simple.

2- Another "grabbing hook" for interfaces (like the ones already
existing for the kernel bridge and for the macvlan).

In include/linux/netdevice.h:
among the fields of struct net_device:

        /* bridge stuff */
	struct net_bridge_port  *br_port;
	/* macvlan */
	struct macvlan_port     *macvlan_port;
+        /* ipn */
+        struct ipn_node        *ipn_port;
		 
	/* class/net/name entry */
	struct device           dev;

In net/core/dev.c, we need another section for grabbing packets....
like the ones defined for CONFIG_BRIDGE and CONFIG_MACVLAN.
I can write the patch (it needs just tens of minutes of cut&paste).
We are studying some way to register/deregister grabbing services,
I feel this would be the cleanest way. 

WHERE?
------
There is an experimental version in the VDE svn tree.
http://sourceforge.net/projects/vde

The current implementation can be compiled as a module on linux >= 2.6.22.
We have currently "stolen" the AF_RXRPC and the kernel bridge hook, thus
this experimental implementation is incompatible with RXRPC and the kernel
bridge (sharing the same data structure). This is just to show the
effectiveness of this idea, in this way it can be compiled as a module
without patching the kernel. 
We'll migrate IPN to its specific AF and grabbing hook as soon as they
have been defined. 

renzo
(V^2 project)
