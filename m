Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbYH3AP1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbYH3AP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 20:15:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYH3APN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 20:15:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34297 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751266AbYH3API (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 20:15:08 -0400
Date: Fri, 29 Aug 2008 17:14:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       bgmerrell@novell.com, hirofuchi@users.sourceforge.net, gregkh@suse.de
Subject: Re: [patch 01/03] USB: USB/IP: add common functions needed
Message-Id: <20080829171449.982480f9.akpm@linux-foundation.org>
In-Reply-To: <20080828230031.GB15014@kroah.com>
References: <20080828225248.758800945@mini.kroah.org>
	<20080828230031.GB15014@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 16:00:31 -0700
greg@kroah.com wrote:

> From: Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>
> 
> This adds the common functions needed by both the host and client side
> of the USB/IP code.
> 
> Brian Merrell cleaned up a lot of this code and submitted it for
> inclusion.  Greg also did a lot of cleanup.
> 
>
> ...
>
> +static ssize_t store_flag(struct device *dev, struct device_attribute *attr,
> +		const char *buf, size_t count)
> +{
> +	unsigned long flag;
> +
> +	sscanf(buf, "%lx", &flag);
> +	usbip_debug_flag = flag;
> +
> +	return count;
> +}

Local variable `flag' is unneeded.

It's a bit sloppy that a user can do

	echo wibble > /sys/whatever-file-this-is

and that will set usbip_debug_flag to zero.  We should have a library
function somewhere which can be used for this very common pattern.

Something like

/*
 * Convert an optionally NULL-terminated digit string into a long.  Returns
 * a -ve errno if an invalid character was detected.  Otherwise returns the 
 * number of characters whcih were consumed from the input.
 */
int sysfs_parse_long(const char *buf, long *ret)
{
	...
}

then the above becomes

static ssize_t store_flag(struct device *dev, struct device_attribute *attr,
		const char *buf, size_t count)
{
	return sysfs_parse_long(buf, &usbip_debug_flag);
}


(probably wrong, but you get the idea).


> +DEVICE_ATTR(usbip_debug, (S_IRUGO | S_IWUSR), show_flag, store_flag);

> +
> +static void usbip_dump_buffer(char *buff, int bufflen)
> +{
> +	int i;
> +
> +	if (bufflen > 128) {
> +		for (i = 0; i < 128; i++) {
> +			if (i%24 == 0)
> +				printk("   ");
> +			printk("%02x ", (unsigned char) buff[i]);
> +			if (i%4 == 3)
> +				printk("| ");
> +			if (i%24 == 23)
> +				printk("\n");
> +		}
> +		printk("... (%d byte)\n", bufflen);
> +		return;
> +	}
> +
> +	for (i = 0; i < bufflen; i++) {
> +		if (i%24 == 0)
> +			printk("   ");
> +		printk("%02x ", (unsigned char) buff[i]);
> +		if (i%4 == 3)
> +			printk("| ");
> +		if (i%24 == 23)
> +			printk("\n");
> +	}
> +	printk("\n");
> +
> +}

Please use lib/hexdump.c

> +static void usbip_dump_pipe(unsigned int p)
> +{
> +	unsigned char type = usb_pipetype(p);
> +	unsigned char ep = usb_pipeendpoint(p);
> +	unsigned char dev = usb_pipedevice(p);
> +	unsigned char dir = usb_pipein(p);
> +
> +	printk("dev(%d) ", dev);
> +	printk("ep(%d) ",  ep);
> +	printk("%s ", dir ? "IN" : "OUT");
> +
> +	switch (type) {
> +	case PIPE_ISOCHRONOUS:
> +		printk("%s ", "ISO");
> +		break;
> +	case PIPE_INTERRUPT:
> +		printk("%s ", "INT");
> +		break;
> +	case PIPE_CONTROL:
> +		printk("%s ", "CTL");
> +		break;
> +	case PIPE_BULK:
> +		printk("%s ", "BLK");
> +		break;
> +	default:
> +		printk("ERR");
> +	}
> +
> +	printk("\n");
> +
> +}
> +
> +static void usbip_dump_usb_device(struct usb_device *udev)
> +{
> +	struct device *dev = &udev->dev;
> +	int i;
> +
> +	dev_dbg(dev, "       devnum(%d) devpath(%s)",
> +		udev->devnum, udev->devpath);
> +
> +	switch (udev->speed) {
> +	case USB_SPEED_HIGH:
> +		printk(" SPD_HIGH");
> +		break;
> +	case USB_SPEED_FULL:
> +		printk(" SPD_FULL");
> +		break;
> +	case USB_SPEED_LOW:
> +		printk(" SPD_LOW");
> +		break;
> +	case USB_SPEED_UNKNOWN:
> +		printk(" SPD_UNKNOWN");
> +		break;
> +	default:
> +		printk(" SPD_ERROR");
> +	}
> +
> +	printk(" tt %p, ttport %d", udev->tt, udev->ttport);
> +	printk("\n");
> +
> +	dev_dbg(dev, "                    ");
> +	for (i = 0; i < 16; i++)
> +		printk(" %2u", i);
> +	printk("\n");
> +
> +	dev_dbg(dev, "       toggle0(IN) :");
> +	for (i = 0; i < 16; i++)
> +		printk(" %2u", (udev->toggle[0] & (1 << i)) ? 1 : 0);
> +	printk("\n");
> +
> +	dev_dbg(dev, "       toggle1(OUT):");
> +	for (i = 0; i < 16; i++)
> +		printk(" %2u", (udev->toggle[1] & (1 << i)) ? 1 : 0);
> +	printk("\n");
> +
> +
> +	dev_dbg(dev, "       epmaxp_in   :");
> +	for (i = 0; i < 16; i++) {
> +		if (udev->ep_in[i])
> +			printk(" %2u",
> +			     le16_to_cpu(udev->ep_in[i]->desc.wMaxPacketSize));
> +	}
> +	printk("\n");
> +
> +	dev_dbg(dev, "       epmaxp_out  :");
> +	for (i = 0; i < 16; i++) {
> +		if (udev->ep_out[i])
> +			printk(" %2u",
> +			     le16_to_cpu(udev->ep_out[i]->desc.wMaxPacketSize));
> +	}
> +	printk("\n");
> +
> +	dev_dbg(dev, "parent %p, bus %p\n", udev->parent, udev->bus);
> +
> +	dev_dbg(dev, "descriptor %p, config %p, actconfig %p, "
> +		"rawdescriptors %p\n", &udev->descriptor, udev->config,
> +		udev->actconfig, udev->rawdescriptors);
> +
> +	dev_dbg(dev, "have_langid %d, string_langid %d\n",
> +		udev->have_langid, udev->string_langid);
> +
> +	dev_dbg(dev, "maxchild %d, children %p\n",
> +		udev->maxchild, udev->children);
> +}
> +
> +static void usbip_dump_request_type(__u8 rt)
> +{
> +	switch (rt & USB_RECIP_MASK) {
> +	case USB_RECIP_DEVICE:
> +		printk("DEVICE");
> +		break;
> +	case USB_RECIP_INTERFACE:
> +		printk("INTERF");
> +		break;
> +	case USB_RECIP_ENDPOINT:
> +		printk("ENDPOI");
> +		break;
> +	case USB_RECIP_OTHER:
> +		printk("OTHER ");
> +		break;
> +	default:
> +		printk("------");
> +	}
> +}
> +
> +static void usbip_dump_usb_ctrlrequest(struct usb_ctrlrequest *cmd)
> +{
> +	if (!cmd) {
> +		printk("      %s : null pointer\n", __FUNCTION__);
> +		return;
> +	}
> +
> +	printk("       ");
> +	printk("bRequestType(%02X) ", cmd->bRequestType);
> +	printk("bRequest(%02X) " , cmd->bRequest);
> +	printk("wValue(%04X) ", cmd->wValue);
> +	printk("wIndex(%04X) ", cmd->wIndex);
> +	printk("wLength(%04X) ", cmd->wLength);
> +
> +	printk("\n       ");
> +
> +	if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_STANDARD) {
> +		printk("STANDARD ");
> +		switch (cmd->bRequest) {
> +		case USB_REQ_GET_STATUS:
> +			printk("GET_STATUS");
> +			break;
> +		case USB_REQ_CLEAR_FEATURE:
> +			printk("CLEAR_FEAT");
> +			break;
> +		case USB_REQ_SET_FEATURE:
> +			printk("SET_FEAT  ");
> +			break;
> +		case USB_REQ_SET_ADDRESS:
> +			printk("SET_ADDRRS");
> +			break;
> +		case USB_REQ_GET_DESCRIPTOR:
> +			printk("GET_DESCRI");
> +			break;
> +		case USB_REQ_SET_DESCRIPTOR:
> +			printk("SET_DESCRI");
> +			break;
> +		case USB_REQ_GET_CONFIGURATION:
> +			printk("GET_CONFIG");
> +			break;
> +		case USB_REQ_SET_CONFIGURATION:
> +			printk("SET_CONFIG");
> +			break;
> +		case USB_REQ_GET_INTERFACE:
> +			printk("GET_INTERF");
> +			break;
> +		case USB_REQ_SET_INTERFACE:
> +			printk("SET_INTERF");
> +			break;
> +		case USB_REQ_SYNCH_FRAME:
> +			printk("SYNC_FRAME");
> +			break;
> +		default:
> +			printk("REQ(%02X) ", cmd->bRequest);
> +		}
> +
> +		printk(" ");
> +		usbip_dump_request_type(cmd->bRequestType);
> +
> +	} else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_CLASS)
> +		printk("CLASS   ");
> +
> +	else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_VENDOR)
> +		printk("VENDOR  ");
> +
> +	else if ((cmd->bRequestType & USB_TYPE_MASK) == USB_TYPE_RESERVED)
> +		printk("RESERVED");
> +
> +	printk("\n");
> +}
> +
> +void usbip_dump_urb(struct urb *urb)
> +{
> +	struct device *dev;
> +
> +	if (!urb) {
> +		printk(KERN_DEBUG KBUILD_MODNAME
> +		       ":%s: urb: null pointer!!\n", __func__);
> +		return;
> +	}
> +
> +	if (!urb->dev) {
> +		printk(KERN_DEBUG KBUILD_MODNAME
> +		       ":%s: urb->dev: null pointer!!\n", __func__);
> +		return;
> +	}
> +	dev = &urb->dev->dev;
> +
> +	dev_dbg(dev, "   urb                   :%p\n", urb);
> +	dev_dbg(dev, "   dev                   :%p\n", urb->dev);
> +
> +	usbip_dump_usb_device(urb->dev);
> +
> +	dev_dbg(dev, "   pipe                  :%08x ", urb->pipe);
> +
> +	usbip_dump_pipe(urb->pipe);
> +
> +	dev_dbg(dev, "   status                :%d\n", urb->status);
> +	dev_dbg(dev, "   transfer_flags        :%08X\n", urb->transfer_flags);
> +	dev_dbg(dev, "   transfer_buffer       :%p\n", urb->transfer_buffer);
> +	dev_dbg(dev, "   transfer_buffer_length:%d\n", urb->transfer_buffer_length);
> +	dev_dbg(dev, "   actual_length         :%d\n", urb->actual_length);
> +	dev_dbg(dev, "   setup_packet          :%p\n", urb->setup_packet);
> +
> +	if (urb->setup_packet && usb_pipetype(urb->pipe) == PIPE_CONTROL)
> +			usbip_dump_usb_ctrlrequest(
> +			(struct usb_ctrlrequest *)urb->setup_packet);
> +
> +	dev_dbg(dev, "   start_frame           :%d\n", urb->start_frame);
> +	dev_dbg(dev, "   number_of_packets     :%d\n", urb->number_of_packets);
> +	dev_dbg(dev, "   interval              :%d\n", urb->interval);
> +	dev_dbg(dev, "   error_count           :%d\n", urb->error_count);
> +	dev_dbg(dev, "   context               :%p\n", urb->context);
> +	dev_dbg(dev, "   complete              :%p\n", urb->complete);
> +}
> +EXPORT_SYMBOL(usbip_dump_urb);
> +
> +void usbip_dump_header(struct usbip_header *pdu)
> +{
> +	udbg("BASE: cmd %u seq %u devid %u dir %u ep %u\n",
> +			pdu->base.command,
> +			pdu->base.seqnum,
> +			pdu->base.devid,
> +			pdu->base.direction,
> +			pdu->base.ep);
> +
> +	switch (pdu->base.command) {
> +	case USBIP_CMD_SUBMIT:
> +		udbg("CMD_SUBMIT: x_flags %u x_len %u sf %u #p %u iv %u\n",
> +				pdu->u.cmd_submit.transfer_flags,
> +				pdu->u.cmd_submit.transfer_buffer_length,
> +				pdu->u.cmd_submit.start_frame,
> +				pdu->u.cmd_submit.number_of_packets,
> +				pdu->u.cmd_submit.interval);
> +				break;
> +	case USBIP_CMD_UNLINK:
> +		udbg("CMD_UNLINK: seq %u\n", pdu->u.cmd_unlink.seqnum);
> +		break;
> +	case USBIP_RET_SUBMIT:
> +		udbg("RET_SUBMIT: st %d al %u sf %d ec %d\n",
> +				pdu->u.ret_submit.status,
> +				pdu->u.ret_submit.actual_length,
> +				pdu->u.ret_submit.start_frame,
> +				pdu->u.ret_submit.error_count);
> +	case USBIP_RET_UNLINK:
> +		udbg("RET_UNLINK: status %d\n", pdu->u.ret_unlink.status);
> +		break;
> +	default:
> +		/* NOT REACHED */
> +		udbg("UNKNOWN\n");
> +	}
> +}
> +EXPORT_SYMBOL(usbip_dump_header);
> +

There's a heck of a lot of debugging code there.  It'd be good to have
some way of making it config-time optional, if it isn't already.


> +/*-------------------------------------------------------------------------*/
> +/* thread routines */
> +
> +int usbip_thread(void *param)
> +{
> +	struct usbip_task *ut = param;
> +
> +	if (!ut)
> +		return -EINVAL;
> +
> +	lock_kernel();
> +	daemonize(ut->name);
> +	allow_signal(SIGKILL);
> +	ut->thread = current;
> +	unlock_kernel();
> +
> +	/* srv.rb must wait for rx_thread starting */
> +	complete(&ut->thread_done);
> +
> +	/* start of while loop */
> +	ut->loop_ops(ut);
> +
> +	/* end of loop */
> +	ut->thread = NULL;
> +
> +	complete_and_exit(&ut->thread_done, 0);
> +}

no no no no no.  Use the kthread interface.

> +void usbip_start_threads(struct usbip_device *ud)
> +{
> +	/*
> +	 * threads are invoked per one device (per one connection).
> +	 */
> +	kernel_thread(usbip_thread, (void *)&ud->tcp_rx, 0);
> +	kernel_thread(usbip_thread, (void *)&ud->tcp_tx, 0);
> +
> +	/* confirm threads are starting */
> +	wait_for_completion(&ud->tcp_rx.thread_done);
> +	wait_for_completion(&ud->tcp_tx.thread_done);
> +}
> +EXPORT_SYMBOL(usbip_start_threads);
> +
> +void usbip_stop_threads(struct usbip_device *ud)
> +{
> +	/* kill threads related to this sdev, if v.c. exists */
> +	if (ud->tcp_rx.thread != NULL) {
> +		send_sig(SIGKILL, ud->tcp_rx.thread, 1);
> +		wait_for_completion(&ud->tcp_rx.thread_done);
> +		udbg("rx_thread for ud %p has finished\n", ud);
> +	}
> +
> +	if (ud->tcp_tx.thread != NULL) {
> +		send_sig(SIGKILL, ud->tcp_tx.thread, 1);
> +		wait_for_completion(&ud->tcp_tx.thread_done);
> +		udbg("tx_thread for ud %p has finished\n", ud);
> +	}
> +}
> +EXPORT_SYMBOL(usbip_stop_threads);

ditto

> +void usbip_task_init(struct usbip_task *ut, char *name,
> +		void (*loop_ops)(struct usbip_task *))
> +{
> +	ut->thread = NULL;
> +	init_completion(&ut->thread_done);
> +	ut->name = name;
> +	ut->loop_ops = loop_ops;
> +}
> +EXPORT_SYMBOL(usbip_task_init);
> +
> +
> +/*-------------------------------------------------------------------------*/
> +/* socket routines */
> +
> + /*  Send/receive messages over TCP/IP. I refer drivers/block/nbd.c */

hey, that's networking stuff.  Someone tell the networking developers?

> +int usbip_xmit(int send, struct socket *sock, char *buf,
> +	       int size, int msg_flags)
> +{
> +	int result;
> +	struct msghdr msg;
> +	struct kvec iov;
> +	int total = 0;
> +
> +	/* for blocks of if (dbg_flag_xmit) */
> +	char *bp = buf;
> +	int osize = size;
> +
> +	dbg_xmit("enter\n");
> +
> +	if (!sock || !buf || !size) {
> +		printk(KERN_ERR "%s: invalid arg, sock %p buff %p size %d\n",
> +		       __func__, sock, buf, size);
> +		return -EINVAL;
> +	}
> +
> +
> +	if (dbg_flag_xmit) {
> +		if (send) {
> +			if (!in_interrupt())
> +				printk(KERN_DEBUG "%-10s:", current->comm);

Use get_task_comm() here.

> +			else
> +				printk(KERN_DEBUG "interupt  :");

typo.

> +
> +			printk("%s: sending... , sock %p, buf %p, "
> +			       "size %d, msg_flags %d\n", __func__,
> +			       sock, buf, size, msg_flags);
> +			usbip_dump_buffer(buf, size);
> +		}
> +	}
> +
> +
> +	do {
> +		sock->sk->sk_allocation = GFP_NOIO;
> +		iov.iov_base    = buf;
> +		iov.iov_len     = size;
> +		msg.msg_name    = NULL;
> +		msg.msg_namelen = 0;
> +		msg.msg_control = NULL;
> +		msg.msg_controllen = 0;
> +		msg.msg_namelen    = 0;
> +		msg.msg_flags      = msg_flags | MSG_NOSIGNAL;
> +
> +		if (send)
> +			result = kernel_sendmsg(sock, &msg, &iov, 1, size);
> +		else
> +			result = kernel_recvmsg(sock, &msg, &iov, 1, size,
> +								MSG_WAITALL);
> +
> +		if (result <= 0) {
> +			udbg("usbip_xmit: %s sock %p buf %p size %u ret %d"
> +					" total %d\n",
> +					send ? "send" : "receive", sock, buf,
> +					size, result, total);
> +			goto err;
> +		}
> +
> +		size -= result;
> +		buf += result;
> +		total += result;
> +
> +	} while (size > 0);
> +
> +
> +	if (dbg_flag_xmit) {
> +		if (!send) {
> +			if (!in_interrupt())
> +				printk(KERN_DEBUG "%-10s:", current->comm);

ditto

> +			else
> +				printk(KERN_DEBUG "interupt  :");

ditto

> +
> +			printk("usbip_xmit: receiving....\n");
> +			usbip_dump_buffer(bp, osize);
> +			printk("usbip_xmit: received, osize %d ret %d size %d "
> +					"total %d\n", osize, result, size,
> +					total);
> +		}
> +
> +		if (send)
> +			printk("usbip_xmit: send, total %d\n", total);
> +	}
> +
> +	return total;
> +
> +err:
> +	return result;
> +}
> +EXPORT_SYMBOL(usbip_xmit);
> +
> +
> +/* now a usrland utility should set options. */
> +#if 0

kill this?

> +int setquickack(struct socket *socket)
> +{
> +	mm_segment_t oldfs;
> +	int val = 1;
> +	int ret;
> +
> +	oldfs = get_fs();
> +	set_fs(get_ds());
> +	ret = socket->ops->setsockopt(socket, SOL_TCP, TCP_QUICKACK,
> +			(char __user *) &val, sizeof(ret));
> +	set_fs(oldfs);
> +
> +	return ret;
> +}
> +
> +int setnodelay(struct socket *socket)
> +{
> +	mm_segment_t oldfs;
> +	int val = 1;
> +	int ret;
> +
> +	oldfs = get_fs();
> +	set_fs(get_ds());
> +	ret = socket->ops->setsockopt(socket, SOL_TCP, TCP_NODELAY,
> +			(char __user *) &val, sizeof(ret));
> +	set_fs(oldfs);
> +
> +	return ret;
> +}
> +
> +int setkeepalive(struct socket *socket)
> +{
> +	mm_segment_t oldfs;
> +	int val = 1;
> +	int ret;
> +
> +	oldfs = get_fs();
> +	set_fs(get_ds());
> +	ret = socket->ops->setsockopt(socket, SOL_SOCKET, SO_KEEPALIVE,
> +			(char __user *) &val, sizeof(ret));
> +	set_fs(oldfs);
> +
> +	return ret;
> +}
> +
> +void setreuse(struct socket *socket)
> +{
> +	socket->sk->sk_reuse = 1;
> +}
> +#endif
> +
> +struct socket *sockfd_to_socket(unsigned int sockfd)
> +{
> +	struct socket *socket;
> +	struct file *file;
> +	struct inode *inode;
> +
> +	file = fget(sockfd);
> +	if (!file) {
> +		printk(KERN_ERR "%s: invalid sockfd\n", __func__);
> +		return NULL;
> +	}
> +
> +	inode = file->f_dentry->d_inode;
> +
> +	if (!inode || !S_ISSOCK(inode->i_mode))
> +		return NULL;

Can file->f_dentry->d_inode ever be NULL??

> +	socket = SOCKET_I(inode);
> +
> +	return socket;
> +}
> +EXPORT_SYMBOL(sockfd_to_socket);
> +
> +
> +
> +/*-------------------------------------------------------------------------*/
> +/* pdu routines */
> +
> +/* there may be more cases to tweak the flags. */
> +static unsigned int tweak_transfer_flags(unsigned int flags)
> +{
> +
> +	if (flags & URB_NO_TRANSFER_DMA_MAP)
> +		/*
> +		 * vhci_hcd does not provide DMA-mapped I/O. The upper
> +		 * driver does not need to set this flag. The remote
> +		 * usbip.ko does not still perform DMA-mapped I/O for
> +		 * DMA-caplable host controllers. So, clear this flag.
> +		 */
> +		flags &= ~URB_NO_TRANSFER_DMA_MAP;
> +
> +	if (flags & URB_NO_SETUP_DMA_MAP)
> +		flags &= ~URB_NO_SETUP_DMA_MAP;

	flags &= ~(URB_NO_TRANSFER_DMA_MAP|URB_NO_SETUP_DMA_MAP);

> +	return flags;
> +}
> +
> +static void usbip_pack_cmd_submit(struct usbip_header *pdu, struct urb *urb,
> +								int pack)
> +{
> +	struct usbip_header_cmd_submit *spdu = &pdu->u.cmd_submit;
> +
> +	/*
> +	 * Some members are not still implemented in usbip. I hope this issue
> +	 * will be discussed when usbip is ported to other operating systems.
> +	 */
> +	if (pack) {
> +		/* vhci_tx.c */
> +		spdu->transfer_flags =
> +				tweak_transfer_flags(urb->transfer_flags);
> +		spdu->transfer_buffer_length	= urb->transfer_buffer_length;
> +		spdu->start_frame		= urb->start_frame;
> +		spdu->number_of_packets		= urb->number_of_packets;
> +		spdu->interval			= urb->interval;
> +	} else  {
> +		/* stub_rx.c */
> +		urb->transfer_flags         = spdu->transfer_flags;
> +
> +		urb->transfer_buffer_length = spdu->transfer_buffer_length;
> +		urb->start_frame            = spdu->start_frame;
> +		urb->number_of_packets      = spdu->number_of_packets;
> +		urb->interval               = spdu->interval;
> +	}
> +}
>
> ...
>
> +/* some members of urb must be substituted before. */
> +int usbip_recv_iso(struct usbip_device *ud, struct urb *urb)
> +{
> +	void *buff;
> +	struct usbip_iso_packet_descriptor *iso;
> +	int np = urb->number_of_packets;
> +	int size = np * sizeof(*iso);
> +	int i;
> +	int ret;
> +
> +	if (!usb_pipeisoc(urb->pipe))
> +		return 0;
> +
> +	/* my Bluetooth dongle gets ISO URBs which are np = 0 */
> +	if (np == 0) {
> +		/* uinfo("iso np == 0\n"); */
> +		/* usbip_dump_urb(urb); */
> +		return 0;
> +	}
> +
> +	buff = kzalloc(size, GFP_KERNEL);

Do all these kzalloc()s really need to zero out the memory?

> +	if (!buff)
> +		return -ENOMEM;
> +
> +	ret = usbip_xmit(0, ud->tcp_socket, buff, size, 0);
> +	if (ret != size) {
> +		dev_err(&urb->dev->dev, "recv iso_frame_descriptor, %d\n",
> +			ret);
> +		kfree(buff);
> +
> +		if (ud->side == USBIP_STUB)
> +			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
> +		else
> +			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
> +
> +		return -EPIPE;
> +	}
> +
> +	for (i = 0; i < np; i++) {
> +		iso = buff + (i * sizeof(*iso));
> +
> +		usbip_iso_pakcet_correct_endian(iso, 0);
> +		usbip_pack_iso(iso, &urb->iso_frame_desc[i], 0);
> +	}
> +
> +
> +	kfree(buff);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(usbip_recv_iso);
> +
> +
> +/* some members of urb must be substituted before. */
> +int usbip_recv_xbuff(struct usbip_device *ud, struct urb *urb)
> +{
> +	int ret;
> +	int size;
> +
> +	if (ud->side == USBIP_STUB) {
> +		/* stub_rx.c */
> +		/* the direction of urb must be OUT. */
> +		if (usb_pipein(urb->pipe))
> +			return 0;
> +
> +		size = urb->transfer_buffer_length;
> +	} else {
> +		/* vhci_rx.c */
> +		/* the direction of urb must be IN. */
> +		if (usb_pipeout(urb->pipe))
> +			return 0;
> +
> +		size = urb->actual_length;
> +	}
> +
> +	/* no need to recv xbuff */
> +	if (!(size > 0))
> +		return 0;

can `size' really be less than zero?

> +	ret = usbip_xmit(0, ud->tcp_socket, (char *)urb->transfer_buffer,
> +			 size, 0);
> +	if (ret != size) {
> +		dev_err(&urb->dev->dev, "recv xbuf, %d\n", ret);
> +		if (ud->side == USBIP_STUB) {
> +			usbip_event_add(ud, SDEV_EVENT_ERROR_TCP);
> +		} else {
> +			usbip_event_add(ud, VDEV_EVENT_ERROR_TCP);
> +			return -EPIPE;
> +		}
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(usbip_recv_xbuff);
> +
> +
>
> ...
>
> --- /dev/null
> +++ b/drivers/usb/ip/usbip_common.h
> @@ -0,0 +1,406 @@
> +/*
> + * Copyright (C) 2003-2008 Takahiro Hirofuchi
> + *
> + * This is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
> + * USA.
> + */
> +
> +#ifndef __VHCI_COMMON_H
> +#define __VHCI_COMMON_H
> +
> +
> +#include <linux/version.h>
> +#include <linux/usb.h>
> +#include <asm/byteorder.h>
> +#include <net/sock.h>
> +
> +/*-------------------------------------------------------------------------*/
> +
> +/*
> + * define macros to print messages
> + */
> +
> +/**
> + * udbg - print debug messages if CONFIG_USB_DEBUG is defined
> + * @fmt:
> + * @args:

?

> + */
> +
> +#ifdef CONFIG_USB_DEBUG

Is it appropriate that this be under CONFIG_USB_DEBUG?  Or should there
be a usbip-specific config variable?

> +#define udbg(fmt, args...)						\
> +	do {								\
> +		printk(KERN_DEBUG "%-10s:(%s,%d) %s: " fmt,		\
> +			(in_interrupt() ? "interrupt" : (current)->comm),\
> +			__FILE__, __LINE__, __func__, ##args);	\
> +	} while (0)
> +
> +#else  /* CONFIG_USB_DEBUG */
> +
> +#define udbg(fmt, args...)		do { } while (0)
> +
> +#endif /* CONFIG_USB_DEBUG */
> +
> +
> +enum {
> +	usbip_debug_xmit	= (1 << 0),
> +	usbip_debug_sysfs	= (1 << 1),
> +	usbip_debug_urb		= (1 << 2),
> +	usbip_debug_eh		= (1 << 3),
> +
> +	usbip_debug_stub_cmp	= (1 << 8),
> +	usbip_debug_stub_dev	= (1 << 9),
> +	usbip_debug_stub_rx	= (1 << 10),
> +	usbip_debug_stub_tx	= (1 << 11),
> +
> +	usbip_debug_vhci_rh	= (1 << 8),
> +	usbip_debug_vhci_hc	= (1 << 9),
> +	usbip_debug_vhci_rx	= (1 << 10),
> +	usbip_debug_vhci_tx	= (1 << 11),
> +	usbip_debug_vhci_sysfs  = (1 << 12)

There are four duplicates there.  That seems odd.

> +};
> +
> +#define dbg_flag_xmit		(usbip_debug_flag & usbip_debug_xmit)
> +#define dbg_flag_vhci_rh	(usbip_debug_flag & usbip_debug_vhci_rh)
> +#define dbg_flag_vhci_hc	(usbip_debug_flag & usbip_debug_vhci_hc)
> +#define dbg_flag_vhci_rx	(usbip_debug_flag & usbip_debug_vhci_rx)
> +#define dbg_flag_vhci_tx	(usbip_debug_flag & usbip_debug_vhci_tx)
> +#define dbg_flag_vhci_sysfs	(usbip_debug_flag & usbip_debug_vhci_sysfs)
> +#define dbg_flag_stub_rx	(usbip_debug_flag & usbip_debug_stub_rx)
> +#define dbg_flag_stub_tx	(usbip_debug_flag & usbip_debug_stub_tx)
>
> +extern unsigned long usbip_debug_flag;
> +extern struct device_attribute dev_attr_usbip_debug;
> +
> +#define dbg_with_flag(flag, fmt, args...)		\
> +	do {						\
> +		if (flag & usbip_debug_flag)		\
> +			udbg(fmt , ##args);		\
> +	} while (0)
> +
> +#define dbg_sysfs(fmt, args...)		\
> +	dbg_with_flag(usbip_debug_sysfs, fmt , ##args)
> +#define dbg_xmit(fmt, args...)		\
> +	dbg_with_flag(usbip_debug_xmit, fmt , ##args)
> +#define dbg_urb(fmt, args...)		\
> +	dbg_with_flag(usbip_debug_urb, fmt , ##args)
> +#define dbg_eh(fmt, args...)		\
> +	dbg_with_flag(usbip_debug_eh, fmt , ##args)
> +
> +#define dbg_vhci_rh(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_vhci_rh, fmt , ##args)
> +#define dbg_vhci_hc(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_vhci_hc, fmt , ##args)
> +#define dbg_vhci_rx(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_vhci_rx, fmt , ##args)
> +#define dbg_vhci_tx(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_vhci_tx, fmt , ##args)
> +#define dbg_vhci_sysfs(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_vhci_sysfs, fmt , ##args)
> +
> +#define dbg_stub_cmp(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_stub_cmp, fmt , ##args)
> +#define dbg_stub_rx(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_stub_rx, fmt , ##args)
> +#define dbg_stub_tx(fmt, args...)	\
> +	dbg_with_flag(usbip_debug_stub_tx, fmt , ##args)

This header adds a lot of symbols which have fairly generic-sounding
names and which don't have "usbip" within them.  There is a risk that
we will later clash with some other header file's dbg_sysfs.

> +
> +/**
> + * uerr - print error messages
> + * @fmt:
> + * @args:
> + */
> +#define uerr(fmt, args...)						\
> +	do {								\
> +		printk(KERN_ERR "%-10s: ***ERROR*** (%s,%d) %s: " fmt,	\
> +			(in_interrupt() ? "interrupt" : (current)->comm),\
> +			__FILE__, __LINE__, __func__, ##args);	\
> +	} while (0)
> +
> +/**
> + * uinfo - print information messages
> + * @fmt:
> + * @args:
> + */
> +#define uinfo(fmt, args...)					\
> +	do {							\
> +		printk(KERN_INFO "usbip: " fmt , ## args);	\
> +	} while (0)

These two are risky also.

> +
> +/*-------------------------------------------------------------------------*/
> +
> +/*
> + * USB/IP request headers.
> + * Currently, we define 4 request types:
> + *
> + *  - CMD_SUBMIT transfers a USB request, corresponding to usb_submit_urb().
> + *    (client to server)
> + *  - RET_RETURN transfers the result of CMD_SUBMIT.
> + *    (server to client)
> + *  - CMD_UNLINK transfers an unlink request of a pending USB request.
> + *    (client to server)
> + *  - RET_UNLINK transfers the result of CMD_UNLINK.
> + *    (server to client)
> + *
> + * Note: The below request formats are based on the USB subsystem of Linux. Its
> + * details will be defined when other implementations come.
> + *
> + *
> + */

I assume the below data structures are known about by userspace?

If so, the comment should make that very very clear.  This is part of
the kernel ABI.

Is this interface versioned?  If not, should it be?

This header doesn't appear to have __KERNEL__ guards.  Should we be
aiming to be able to use this header directly within userspace
compilation?

> +/*
> + * A basic header followed by other additional headers.
> + */
> +struct usbip_header_basic {
> +#define USBIP_CMD_SUBMIT	0x0001
> +#define USBIP_CMD_UNLINK	0x0002
> +#define USBIP_RET_SUBMIT	0x0003
> +#define USBIP_RET_UNLINK	0x0004
> +	__u32 command;
> +
> +	 /* sequencial number which identifies requests.
> +	  * incremented per connections */
> +	__u32 seqnum;
> +
> +	/* devid is used to specify a remote USB device uniquely instead
> +	 * of busnum and devnum in Linux. In the case of Linux stub_driver,
> +	 * this value is ((busnum << 16) | devnum) */
> +	__u32 devid;
> +
> +#define USBIP_DIR_OUT	0
> +#define USBIP_DIR_IN 	1
> +	__u32 direction;
> +	__u32 ep;     /* endpoint number */
> +} __attribute__ ((packed));
> +
>
> ...
>
> +
> +
> +int usbip_xmit(int, struct socket *, char *, int, int);
> +int usbip_sendmsg(struct socket *, struct msghdr *, int);
> +
> +
> +static inline int interface_to_busnum(struct usb_interface *interface)
> +{
> +	struct usb_device *udev = interface_to_usbdev(interface);
> +	return udev->bus->busnum;
> +}
> +
> +static inline int interface_to_devnum(struct usb_interface *interface)
> +{
> +	struct usb_device *udev = interface_to_usbdev(interface);
> +	return udev->devnum;
> +}
> +
> +static inline int interface_to_infnum(struct usb_interface *interface)
> +{
> +	return interface->cur_altsetting->desc.bInterfaceNumber;
> +}
> +
> +#if 0

kill?

> +int setnodelay(struct socket *);
> +int setquickack(struct socket *);
> +int setkeepalive(struct socket *socket);
> +void setreuse(struct socket *);
> +#endif
> +
> +struct socket *sockfd_to_socket(unsigned int);
> +int set_sockaddr(struct socket *socket, struct sockaddr_storage *ss);
> +
> +void usbip_dump_urb(struct urb *purb);
> +void usbip_dump_header(struct usbip_header *pdu);
> +
> +
>
> ...
>
> +static void event_handler_loop(struct usbip_task *ut)
> +{
> +	struct usbip_device *ud = container_of(ut, struct usbip_device, eh);
> +
> +	while (1) {
> +		if (signal_pending(current)) {
> +			dbg_eh("signal catched!\n");
> +			break;
> +		}
> +
> +		if (event_handler(ud) < 0)
> +			break;
> +
> +		wait_event_interruptible(ud->eh_waitq, usbip_event_happend(ud));
> +		dbg_eh("wakeup\n");
> +	}
> +}

hm.  So we sit there waiting for a wakeup and each time one occurs we
will assume that there is a single event waiting at ut->event.

I don't see handshaking in event_handler().  It looks like this will be
rich with races and overruns.  But I didn't look for the sending side.

> +void usbip_start_eh(struct usbip_device *ud)
> +{
> +	struct usbip_task *eh = &ud->eh;
> +
> +	init_waitqueue_head(&ud->eh_waitq);
> +	ud->event = 0;
> +
> +	usbip_task_init(eh, "usbip_eh", event_handler_loop);
> +
> +	kernel_thread(usbip_thread, (void *)eh, 0);
> +
> +	wait_for_completion(&eh->thread_done);
> +}
> +EXPORT_SYMBOL(usbip_start_eh);
> +
> +void usbip_stop_eh(struct usbip_device *ud)
> +{
> +	struct usbip_task *eh = &ud->eh;
> +
> +	wait_for_completion(&eh->thread_done);
> +	dbg_eh("usbip_eh has finished\n");
> +}
> +EXPORT_SYMBOL(usbip_stop_eh);
> +
> +void usbip_event_add(struct usbip_device *ud, unsigned long event)
> +{
> +	spin_lock(&ud->lock);
> +
> +	ud->event |= event;
> +
> +	wake_up(&ud->eh_waitq);
> +
> +	spin_unlock(&ud->lock);
> +}
> +EXPORT_SYMBOL(usbip_event_add);
> +
> +int usbip_event_happend(struct usbip_device *ud)

"happened"

> +{
> +	int happend = 0;

"happened"

> +	spin_lock(&ud->lock);
> +
> +	if (ud->event != 0)
> +		happend = 1;
> +
> +	spin_unlock(&ud->lock);
> +
> +	return happend;
> +}
> +EXPORT_SYMBOL(usbip_event_happend);

It all does look rather racy.  In what context does usbip_recv_iso()
get called?  I hope it isn't rx interrupt :(


> --- a/drivers/usb/Kconfig
> +++ b/drivers/usb/Kconfig
> @@ -101,6 +101,8 @@ source "drivers/usb/host/Kconfig"
>  
>  source "drivers/usb/musb/Kconfig"
>  
> +source "drivers/usb/ip/Kconfig"
> +
>  source "drivers/usb/class/Kconfig"
>  
>  source "drivers/usb/storage/Kconfig"
> --- a/drivers/usb/Makefile
> +++ b/drivers/usb/Makefile
> @@ -19,6 +19,8 @@ obj-$(CONFIG_USB_R8A66597_HCD)	+= host/
>  
>  obj-$(CONFIG_USB_C67X00_HCD)	+= c67x00/
>  
> +obj-$(CONFIG_USB_IP_COMMON)	+= ip/
> +
>  obj-$(CONFIG_USB_ACM)		+= class/
>  obj-$(CONFIG_USB_PRINTER)	+= class/

