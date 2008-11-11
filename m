Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYKKGsn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYKKGsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 01:48:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbYKKGsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 01:48:32 -0500
Received: from li2-213.members.linode.com ([69.56.173.213]:44708 "EHLO
	mail.zilogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbYKKGsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 01:48:31 -0500
Message-ID: <49192D0E.2000600@bravegnu.org>
Date: Tue, 11 Nov 2008 12:28:22 +0530
From: Vijay Kumar <vijaykumar@bravegnu.org>
User-Agent: Icedove 1.5.0.10 (X11/20070328)
MIME-Version: 1.0
To: benh@kernel.crashing.org
CC: "J.R. Mauro" <jrm8005@gmail.com>, Christoph Hellwig <hch@infradead.org>,
       Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, jayakumar.lkml@gmail.com,
       sparclinux@vger.kernel.org
Subject: Re: sparc/staging compile error
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>	 <20081106063709.GB7728@kroah.com>	 <18706.51153.342079.586525@cargo.ozlabs.ibm.com>	 <3aaafc130811060606p1dfbf12cr8c0dc8cd310d0279@mail.gmail.com>	 <20081106173224.GA25767@infradead.org>	 <3aaafc130811060936u371e8b9eyccd0c52693f4c433@mail.gmail.com>	 <4913FEE1.9030807@bravegnu.org> <1226099192.13603.78.camel@pasglop>
In-Reply-To: <1226099192.13603.78.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> In any case, we would need to understand better your driver userspace
> API and transfer model to find the right solution.

Please find below the user space skeleton code, to access the driver. It 
was written by Robert Fitzsimons robfitz@273k.net The driver is based on 
this user space interface.

In short, there is a ring buffer that is shared between the _device_ and 
_user-space_. The ring buffer has a header, that is shared between the 
_kernel_ and _user-space_.

The header specifies the offsets of various buffers in the ring buffer. In 
Rx, after user space has read a buffer, the user space writes -1 to the 
offset in the header. When the device has filled the buffer, the kernel 
space writes the offset back to the header.

#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>

#define G_USED -1

struct group_circular_buffer {
	int32_t group_size_bytes;
	int32_t group_count;
	int32_t group_offset[0];
};

int sysfs_write_long(const char *name, long value);
int sysfs_read_long(const char *name, long *value);
int sysfs_read_buffer(const char *name, void *buffer, int len);
int process_group(void *group, int32_t group_size_bytes);

int main(int argc, char **argv)
{
	int uio_fd;
	int rx_fd;
	int group_index;
	long mmap_buffer_size;
	struct pollfd poll_fds;
	struct group_circular_buffer *ring;
	char buffer[128];

	/* Query supported device and channels */
	sysfs_read_buffer("/sys/.../uioX/name", buffer, sizeof(buffer));
	sysfs_read_buffer("/sys/.../uioX/version", buffer, sizeof(buffer));
	sysfs_read_buffer("/sys/.../uioX/channels", buffer, sizeof(buffer));

	/* Open and mmap UIO device */
	uio_fd = open("/dev/.../uioX", O_RDWR);
	// uio_mmap = mmap(..., uio_fd, ...); /* map BAR1 */

	/* Configure 1 megabyte receive dma buffer */
	sysfs_write_long("/sys/.../uioX/rx0/block_size", 512);
	sysfs_write_long("/sys/.../uioX/rx0/group_size", 1);
	sysfs_write_long("/sys/.../uioX/rx0/group_count", 256);

	// configure user firmware, uio_mmap

	/* Open rx char device, which allocates suitable dma/mmap buffers */
	rx_fd = open("/dev/.../uioX/rx0", O_RDWR);

	/* Query size of mmap buffer, maybe use mmap for this value? */
	sysfs_read_long("/sys/.../uioX/rx0/mmap_buffer_size", &mmap_buffer_size);

	ring = mmap(NULL, mmap_buffer_size, PROT_READ | PROT_WRITE, MAP_SHARED, 
rx_fd, 0);

	// start/reset capture, uio_mmap

	group_index = 0;

	while (1) {
		if (ring->group_offset[group_index] > 0) {
			process_group(ring + ring->group_offset[group_index], 
ring->group_size_bytes);

			ring->group_offset[group_index] = G_USED;

			group_index = (group_index + 1) % ring->group_count;
		} else {
			poll_fds.fd = rx_fd;
			poll_fds.events = POLLIN | POLLERR;
			poll_fds.revents = 0;

			poll(&poll_fds, 1, -1);
		}
	}

	// stop capture, uio_mmap

	// munmap(ring)
	// munmap(uio_mmap)
	close(rx_fd);
	close(uio_fd);

	return 0;
}

int sysfs_write_long(const char *name, long value)
{
	return 0;
}

int sysfs_read_long(const char *name, long *value)
{
	return 0;
}

int sysfs_read_buffer(const char *name, void *buffer, int len)
{
	return 0;
}

int process_group(void *group, int32_t group_size_bytes)
{
	return 0;
}


Regards,
Vijay
