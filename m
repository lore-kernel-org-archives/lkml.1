Return-Path: <linux-kernel-owner+w=401wt.eu-S1753768AbXJ1PTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbXJ1PTk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751597AbXJ1PTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:19:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:30429 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXJ1PTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:19:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=Dum/jfKYHu2KTWMcHZLZEjP7DiA8FGt+dt6cvp51XVIVe030FJS8i76IZlMfL1jarQn8kBe4jZWVelay1ia0zVft2pHMx+Xgs6C7909Uyytf4e8M+k/Tw13yTpbgJIE2TRWvmVT0VEOW6Ru5i5kPdocVu6Ejuo3BcbKmgcwVwyA=
Message-ID: <713fe210710280819h22a30bf4hfde7054c30e5dc0e@mail.gmail.com>
Date: Sun, 28 Oct 2007 23:19:29 +0800
From: "Anand Anand" <taknevski@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: adding header in kernel to data passed from user space
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My name is anand and I am trying to develop a system call that adds
twelve bytes of header to data passed from user space. This twelve
bytes of data is to facilitate the RTP (Real-time Transport Protocol)
. Basically the file rtpsendto.c contains my code for the systemc
call. It calls two external functions rtpsendmsg in udp.c and
ip_generic_getfrag_anand in ip_output.c. I modified and added theses
two functions to /usr/src/linux/net/ipv4/udp.c and
/usr/src/linux/net/ipv4/ip_output.c in my distribution.


Basically my rtpsendmsg functions and ip_generic_getfrag_anand
functions are exactly the same as the udpsendmsg and
ip_generic_getfrag function s already present in linux except that
ip_generic_getfrag adds the 12 bytes of header.

I added and compiled the sytem call successfully but it doesnt work
properly. If I send 'anand' from server to client I get the character
ACK on the client side.

I suspect that the header that is 12 bytes does not handle network
byte order, and I think if I pass the number of bytes to be
transferred as a certain number then it doesnt take the extra 12 bytes
into account. Can anyone help me on this? I have cut and paste my code
at the end of this email


Thanks

/* the system call rtpsendto*/




#include<linux/linkage.h>

#include<asm/system.h>

#include<asm/uaccess.h>

#include<asm/ioctls.h>

#include <linux/types.h>

#include<linux/fcntl.h>

#include<linux/module.h>

#include<linux/socket.h>

#include<linux/sockios.h>

#include<linux/igmp.h>

#include<linux/in.h>

#include<linux/errno.h>

#include<linux/timer.h>

#include<linux/mm.h>

#include<linux/inet.h>

#include<linux/ipv6.h>

#include<linux/netdevice.h>

#include<net/snmp.h>

#include<net/ip.h>

#include<net/tcp_states.h>

#include<net/protocol.h>

#include<linux/skbuff.h>

#include<linux/proc_fs.h>

#include<linux/seq_file.h>

#include<net/sock.h>

#include<net/udp.h>

#include<net/icmp.h>

#include<net/route.h>

#include<net/inet_common.h>

#include<net/checksum.h>

#include<net/xfrm.h>

#include<linux/moduleparam.h>

#defineMAX_SOCK_ADDR 128

externint rtpsendmsg(struct sock* sk, struct msghdr *msg, int len);

externint ret_inet_autobind(struct sock* sk);

asmlinkage long sys_rtpsendto(int fd1, char * buff1, size_t
numbytes1,struct sockaddr* to1, int addrlen1 )

{

struct socket *sock1;

struct sock *sk;

char address1[MAX_SOCK_ADDR];

int err1;

struct msghdr msg1;

struct iovec iov1;



sock1 = sockfd_lookup(fd1, &err1);



iov1.iov_base=buff1;

iov1.iov_len=numbytes1;

msg1.msg_name=NULL;

msg1.msg_iov=&iov1;

msg1.msg_iovlen=1;

msg1.msg_control=NULL;

msg1.msg_controllen=0;

msg1.msg_namelen=0;

err1 = move_addr_to_kernel(to1, addrlen1, address1);

msg1.msg_name = address1;

msg1.msg_namelen = addrlen1;

sk = sock1->sk;

// if (sk->num==0 && inet_autobind(sk) != 0)

// return -EAGAIN;



if (!inet_sk(sk)->num && ret_inet_autobind(sk))

return -EAGAIN;

err1 = rtpsendmsg(sk, &msg1, numbytes1);



return err1;

}

/* end of system call rtpsendto */




/* ip_generic_getfrag_anand */


intip_generic_getfrag_anand(void *from, char *to, int offset, int len,
int odd, struct sk_buff *skb){

struct iovec *iov = from;

struct timeval *tv;

long ts2;

static int seqno=0;

// do_gettimeofday(tv);

// static long ts= (long)tv->tv_sec * 1000000 + (long) tv->tv_usec ;



tv = kmalloc(sizeof(struct timeval), GFP_KERNEL);

do_gettimeofday(tv);

ts2= (long)tv->tv_sec * 1000000 + (long) tv->tv_usec ;

// ts2 = ts2 -ts;

to = kmalloc(12*sizeof(char), GFP_KERNEL);

to[0]= 0x80;

to[1]= 0x20;

to[2]= ((seqno%65536)<<16)>>24;

to[3]= ((seqno%65536)<<24)>>24;

to[4]= (ts2<<32)>> 56;

to[5]= (ts2<<40)>>56;

to[6]= (ts2<<48)>>56;

to[7]= (ts2<<56)>>56;

to[8]= 0x40;

to[9]= 0x51;

to[10]= 0x52;

to[11]= 0x34;

if (skb->ip_summed == CHECKSUM_HW) {

if (memcpy_fromiovecend((to+ 12), iov, offset, len) < 0)

return -EFAULT;

} else {

unsigned int csum = 0;

if (csum_partial_copy_fromiovecend((to+ 12), iov, offset, len, &csum) < 0)

return -EFAULT;

skb->csum = csum_block_add(skb->csum, csum, odd);

}

seqno++;

return 0;

}

/*end of ip_generic_getfrag_anand */





/* rtpsendmsg */


intrtpsendmsg(struct sock* sk, struct msghdr *msg, int len){

structinet_sock *inet = inet_sk(sk);

struct udp_sock *up = udp_sk(sk);

int ulen = len;

struct ipcm_cookie ipc;

struct rtable *rt = NULL;

int free = 0;

int connected = 0;

u32 daddr, faddr, saddr;

u16 dport;

u8 tos;

int err;

int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;

if (len > 0xFFFF)

return -EMSGSIZE;

/*

* Check the flags.

*/

if (msg->msg_flags&MSG_OOB) /* Mirror BSD error message compatibility */

return -EOPNOTSUPP;

ipc.opt = NULL;

if (up->pending) {

/*

* There are pending frames.

* The socket lock must be held while it's corked.

*/

lock_sock(sk);

if (likely(up->pending)) {

if (unlikely(up->pending != AF_INET)) {

release_sock(sk);

return -EINVAL;

}

goto do_append_data;

}

release_sock(sk);

}

ulen += sizeof(struct udphdr);

/*

* Get and verify the address.

*/

if (msg->msg_name) {

struct sockaddr_in * usin = (struct sockaddr_in*)msg->msg_name;

if (msg->msg_namelen < sizeof(*usin))

return -EINVAL;

if (usin->sin_family != AF_INET) {

if (usin->sin_family != AF_UNSPEC)

return -EAFNOSUPPORT;

}

daddr = usin->sin_addr.s_addr;

dport = usin->sin_port;

if (dport == 0)

return -EINVAL;

} else {

if (sk->sk_state != TCP_ESTABLISHED)

return -EDESTADDRREQ;

daddr = inet->daddr;

dport = inet->dport;

/* Open fast path for connected socket.

Route will not be used, if at least one option is set.

*/

connected = 1;

}

ipc.addr = inet->saddr;

ipc.oif = sk->sk_bound_dev_if;

if (msg->msg_controllen) {

err = ip_cmsg_send(msg, &ipc);

if (err)

return err;

if (ipc.opt)

free = 1;

connected = 0;

}

if (!ipc.opt)

ipc.opt = inet->opt;

saddr = ipc.addr;

ipc.addr = faddr = daddr;

if (ipc.opt && ipc.opt->srr) {

if (!daddr)

return -EINVAL;

faddr = ipc.opt->faddr;

connected = 0;

}

tos = RT_TOS(inet->tos);

if (sock_flag(sk, SOCK_LOCALROUTE) ||

(msg->msg_flags & MSG_DONTROUTE) ||

(ipc.opt && ipc.opt->is_strictroute)) {

tos |= RTO_ONLINK;

connected = 0;

}

if (MULTICAST(daddr)) {

if (!ipc.oif)

ipc.oif = inet->mc_index;

if (!saddr)

saddr = inet->mc_addr;

connected = 0;

}

if (connected)

rt = (struct rtable*)sk_dst_check(sk, 0);

if (rt == NULL) {

struct flowi fl = { .oif = ipc.oif,

.nl_u = { .ip4_u =

{ .daddr = faddr,

.saddr = saddr,

.tos = tos } },

.proto = IPPROTO_UDP,

.uli_u = { .ports =

{ .sport = inet->sport,

.dport = dport } } };

err = ip_route_output_flow(&rt, &fl, sk, !(msg->msg_flags&MSG_DONTWAIT));

if (err)

goto out;

err = -EACCES;

if ((rt->rt_flags & RTCF_BROADCAST) &&

!sock_flag(sk, SOCK_BROADCAST))

goto out;

if (connected)

sk_dst_set(sk, dst_clone(&rt->u.dst));

}

if (msg->msg_flags&MSG_CONFIRM)

goto do_confirm;

back_from_confirm:

saddr = rt->rt_src;

if (!ipc.addr)

daddr = ipc.addr = rt->rt_dst;

lock_sock(sk);

if (unlikely(up->pending)) {

/* The socket is already corked while preparing it. */

/* ... which is an evident application bug. --ANK */

release_sock(sk);

LIMIT_NETDEBUG(KERN_DEBUG "udp cork app bug 2\n");

err = -EINVAL;

goto out;

}

/*

* Now cork the socket to pend data.

*/

inet->cork.fl.fl4_dst = daddr;

inet->cork.fl.fl_ip_dport = dport;

inet->cork.fl.fl4_src = saddr;

inet->cork.fl.fl_ip_sport = inet->sport;

up->pending = AF_INET;

do_append_data:

up->len += ulen;

err = ip_append_data(sk, ip_generic_getfrag_anand, msg->msg_iov, ulen,

sizeof(struct udphdr), &ipc, rt,

corkreq ? msg->msg_flags|MSG_MORE : msg->msg_flags);

if (err)

udp_flush_pending_frames(sk);

else if (!corkreq)

err = udp_push_pending_frames(sk, up);

release_sock(sk);

out:

ip_rt_put(rt);

if (free)

kfree(ipc.opt);

if (!err) {

UDP_INC_STATS_USER(UDP_MIB_OUTDATAGRAMS);

return len;

}

return err;

do_confirm:

dst_confirm(&rt->u.dst);

if (!(msg->msg_flags&MSG_PROBE) || len)

goto back_from_confirm;

err = 0;

goto out;

}

/*end of rtpsendmsg */
