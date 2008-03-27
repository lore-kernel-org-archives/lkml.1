Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbYC0Seu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbYC0Seu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 14:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYC0Sej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 14:34:39 -0400
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:35095 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbYC0Sei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 14:34:38 -0400
X-Belgacom-Dynamic: yes
Date: Thu, 27 Mar 2008 19:34:37 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Clark <sclark46@earthlink.net>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: iTCO watchdog timer
Message-ID: <20080327183437.GA15490@infomag.infomag.iguana.be>
References: <47CDAC9D.6020505@seclark.us> <20080304135548.b7b88ee4.akpm@linux-foundation.org> <20080306212820.GA2866@infomag.infomag.iguana.be> <47EBE751.1090803@earthlink.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <47EBE751.1090803@earthlink.net>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Steve,

> Just wondered if you had any more thoughts or if you have any test you 
> would like me to run.

Didn't had any time yet. Could you run the following watchdog test-program first and sent me the output?
Just compile it with: gcc -o watchdog watchdog.c and then run the watchdog program.

Thanks,
Wim.


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="watchdog.c"
Content-Transfer-Encoding: 8bit

#include <stdio.h>
#include <unistd.h>
#include <fcntl.h>
#include "linux/ioctl.h"

struct watchdog_info {
	unsigned long options;		/* Options the card/driver supports */
	unsigned long firmware_version;	/* Firmware version of the card */
	unsigned char identity[32];	/* Identity of the board */
};

#define	WATCHDOG_IOCTL_BASE     'W'

#define	WDIOC_GETSUPPORT	_IOR(WATCHDOG_IOCTL_BASE, 0, struct watchdog_info)
#define	WDIOC_GETSTATUS		_IOR(WATCHDOG_IOCTL_BASE, 1, int)
#define	WDIOC_GETBOOTSTATUS	_IOR(WATCHDOG_IOCTL_BASE, 2, int)
#define	WDIOC_GETTEMP		_IOR(WATCHDOG_IOCTL_BASE, 3, int)
#define	WDIOC_SETOPTIONS	_IOR(WATCHDOG_IOCTL_BASE, 4, int)
#define	WDIOC_KEEPALIVE		_IOR(WATCHDOG_IOCTL_BASE, 5, int)
#define	WDIOC_SETTIMEOUT	_IOWR(WATCHDOG_IOCTL_BASE, 6, int)
#define	WDIOC_GETTIMEOUT	_IOR(WATCHDOG_IOCTL_BASE, 7, int)
#define	WDIOC_GETTIMELEFT	_IOR(WATCHDOG_IOCTL_BASE, 10, int)

#define	WDIOS_DISABLECARD	0x0001	/* Turn off the watchdog timer */
#define	WDIOS_ENABLECARD	0x0002	/* Turn on the watchdog timer */

int main(int argc, const char *argv[]) {
	int i = 5;
	int c;
	int temperature;
	int timeout = 34;
	int timervalue;
	int flags;
	int options;
	int ret;
	struct watchdog_info wdinfo;
	int fd=open("/dev/watchdog",O_WRONLY);
	if (fd==-1) {
		perror("watchdog");
		return 1;
	}
	ret = ioctl(fd, WDIOC_GETSUPPORT, &wdinfo);
	printf("The GETSUPPORT call reported (%d):\n", ret);
	if (ret) {
		printf("  options         : ?\n");
		printf("  firmware_version: ?\n");
		printf("  identity        : ?\n");
	} else {
		printf("  options         : 0x%04x\n", wdinfo.options);
		printf("  firmware_version: %d\n", wdinfo.firmware_version);
		printf("  identity        : %s\n", wdinfo.identity);
	}
	ret = ioctl(fd, WDIOC_GETSTATUS, &flags);
	if (ret) flags=0;
	printf("The GETSTATUS call reported %x (%d)\n", flags, ret);
	ret = ioctl(fd, WDIOC_GETBOOTSTATUS, &flags);
	if (ret) flags=0;
	printf("The GETBOOTSTATUS call reported %x (%d)\n", flags, ret);

	ret = ioctl(fd, WDIOC_GETTEMP, &temperature);
	if (ret) temperature=0;
	printf("The GETTEMP call reported %d°F = %d°C (ret=%d)\n", temperature, ((temperature - 32) * 5 / 9), ret);

	options = WDIOS_DISABLECARD;
	ret = ioctl(fd, WDIOC_SETOPTIONS, &options);
	if (ret) options=0;
	printf("The SETOPTIONS (DISABLECARD) call returned=%d\n", ret);
	options = WDIOS_ENABLECARD;
	ret = ioctl(fd, WDIOC_SETOPTIONS, &options);
	if (ret) options=0;
	printf("The SETOPTIONS (ENABLECARD) call returned=%d\n", ret);

	ret = ioctl(fd, WDIOC_GETTIMEOUT, &flags);
	if (ret) flags=0;
	printf("The timeout is %d seconds (%d)\n", flags, ret);
	ret = ioctl(fd, WDIOC_SETTIMEOUT, &timeout);
	if (ret) timeout=0;
	printf("The timeout is now set to %d seconds (%d)\n", timeout, ret);
	ret = ioctl(fd, WDIOC_GETTIMEOUT, &flags);
	if (ret) flags=0;
	printf("The timeout is %d seconds (%d)\n", flags, ret);
	ret = ioctl(fd, WDIOC_GETTIMELEFT, &timervalue);
	if (ret) timervalue=0;
	printf("The GETTIMELEFT call reported %d seconds (0x%04x) (%d)\n", timervalue ,timervalue,ret);
	while(i--) {
		ioctl(fd, WDIOC_KEEPALIVE, 0);
		sleep(10 + i);
		ret = ioctl(fd, WDIOC_GETTIMELEFT, &timervalue);
		if (ret) timervalue=0;
		printf("The GETTIMELEFT call reported %d seconds (0x%04x) (%d)\n", timervalue,timervalue,ret);
	}
	write(fd, "V", 1);
	fsync(fd);
	close(fd);

	return 0;
}


--opJtzjQTFsWo+cga--
