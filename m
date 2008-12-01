Return-Path: <linux-kernel-owner+w=401wt.eu-S1753275AbYLAOjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbYLAOjZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 09:39:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbYLAOjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 09:39:17 -0500
Received: from ppsw-1.csi.cam.ac.uk ([131.111.8.131]:43786 "EHLO
	ppsw-1.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbYLAOjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 09:39:16 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4933F712.2000506@cam.ac.uk>
Date: Mon, 01 Dec 2008 14:39:14 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080801)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: LKML <linux-kernel@vger.kernel.org>, Dmitry Torokhov <dtor@mail.ru>,
       David Brownell <david-b@pacbell.net>, Jean Delvare <khali@linux-fr.org>,
       Ben Nizette <bn@niasdigital.com>,
       LM Sensors <lm-sensors@lm-sensors.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [Industrial I/O] [13/13] RFC: Example user space application
References: <4933F291.4020001@cam.ac.uk>
In-Reply-To: <4933F291.4020001@cam.ac.uk>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan Cameron <jic23@cam.ac.uk>

IIO: Example user space application. Configures and then reads
from a software ring buffer which is filled based on a the
lis3l02dq data ready trigger and is a software ring buffer.

Signed-off-by: Jonathan Cameron <jic23@cam.ac.uk>

--
Quite a lot of this program would be simplified if a couple
of generic library routines were available.  It also illustrates
the necessary separation between user space and kernel space
elements of the IIO headers (cannot currently be used in here
so a couple of things have to be redefined).

 Documentation/industrialio/TestRingLIS3L02DQ.c |  340 ++++++++++++++++++++++++
 1 files changed, 340 insertions(+), 0 deletions(-)

diff --git a/Documentation/industrialio/TestRingLIS3L02DQ.c b/Documentation/industrialio/TestRingLIS3L02DQ.c
new file mode 100644
index 0000000..e963d61
--- /dev/null
+++ b/Documentation/industrialio/TestRingLIS3L02DQ.c
@@ -0,0 +1,340 @@
+/* Industrialio test ring buffer for lis3l02dq
+ *
+ * Copyright (c) 2008 Jonathan Cameron
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * There are numerous places where this code could be shortened but that
+ * is work for another day.  The basic principles are what matter at
+ * this stage.
+ */
+#include <dirent.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <errno.h>
+#include <stdint.h>
+#include <linux/types.h>
+#include <sys/stat.h>
+#include <sys/dir.h>
+
+/* FIXME: Get this from main headers - Separation into userspace
+ * accessible parts and kernel only parts still needs to be done.
+ */
+struct iio_event_data {
+	int id;
+	__s64 timestamp;
+};
+
+#define IIO_EVENT_CODE_RING_50_FULL 200
+#define IIO_EVENT_CODE_RING_75_FULL 201
+#define IIO_EVENT_CODE_RING_100_FULL 202
+/* Returns the base device directory of a named sensor.
+ * This sort of useful function should go in a generic userspace
+ * library */
+char *find_device_by_name(const char *name)
+{
+	const char *iio_dir = "/sys/class/industrialio";
+	const struct dirent *ent;
+	int cnt, pos, pos2;
+	FILE *nameFile;
+	DIR *dp;
+	char thisname[100];
+	char temp[100];
+
+	char *returnstring = NULL;
+	struct stat Stat;
+	pos = sprintf(temp, "%s", iio_dir);
+	pos += sprintf(temp + pos, "/");
+	dp = opendir(iio_dir);
+	if (dp == NULL) {
+		printf("No industrialio devices available");
+		return NULL;
+	}
+	while (ent = readdir(dp), ent != NULL) {
+		cnt++;
+		/*reject . and .. */
+		if (strcmp(ent->d_name, ".") != 0 &&
+		    strcmp(ent->d_name, "..") != 0)  {
+			/*make sure it isn't a trigger!*/
+			if (strncmp(ent->d_name, "iio_trigger", 10) != 0) {
+				/* build full path to new file */
+				pos2 = pos + sprintf(temp+pos, "%s/",
+						     ent->d_name);
+				sprintf(temp+pos2, "name");
+				printf("search location %s\n", temp);
+				nameFile = fopen(temp, "r");
+				if (!nameFile) {
+					sprintf(temp + pos2, "modalias",
+						ent->d_name);
+					nameFile = fopen(temp, "r");
+					if (!nameFile) {
+						printf("Failed to find name\n");
+						return NULL;
+					}
+				}
+				fscanf(nameFile, "%s", thisname);
+				if (strcmp(name, thisname) == 0) {
+					returnstring = malloc(strlen(temp) + 1);
+					sprintf(temp + pos2, "");
+					strcpy(returnstring, temp);
+					return returnstring;
+				}
+				fclose(nameFile);
+
+			}
+		}
+	}
+}
+
+int RingLength = 100;
+int NumVals = 3;
+
+int main(int argc, char **argv)
+{
+	int toread, sample = 0;
+	uint16_t tempx, tempy, tempz;
+	FILE  *sysfsfp, *fp_ev, *ringcont;
+	int fp;
+	char *data;
+	const char *device_name = "lis3l02dq";
+	size_t read_size;
+	int i, j, k, temps;
+	int minor, minor_ev;
+	char name_chrdevevt[100];
+	char name_chrdevring[100];
+	char command[100];
+	int device_no;
+	char temp[200];
+	int pos;
+	struct iio_event_data dat;
+	int scanx = 1, scany = 1, scanz = 1;
+	int scants = 1;
+
+	int datum_size = 0;
+	char *BaseDirectoryName;
+
+	/* Parameters to disable particular channels */
+	for (i = 1; i < argc; i++) {
+		if (strcmp(argv[i], "-x") == 0)
+			scanx = 0;
+		if (strcmp(argv[i], "-y") == 0)
+			scany = 0;
+		if (strcmp(argv[i], "-z") == 0)
+			scanz = 0;
+		if (strcmp(argv[i], "-ts") == 0)
+			scants = 0;
+	}
+	/* Getting the s64 aligned correctly - this will end up in
+	 * the lis3l02dq userspace header
+	 */
+	if (scants && (scanx || scany || scanz))
+		datum_size = 16;
+	else if (scants)
+		datum_size = 8;
+	else {
+		if (scanx)
+			datum_size += sizeof(__s16);
+		if (scany)
+			datum_size += sizeof(__s16);
+		if (scanz)
+			datum_size += sizeof(__s16);
+	}
+	data = malloc(datum_size*RingLength);
+	BaseDirectoryName = find_device_by_name(device_name);
+
+	if (BaseDirectoryName == NULL) {
+		printf("Failed to find the %s \n", device_name);
+		return -1;
+	}
+
+	/* The next section sets up all the device parameters to
+	 * appropriate values before intializing the ring.
+	 */
+	/* Set a sensible ring buffer length */
+	sprintf(temp, "%sring_buffer/length", BaseDirectoryName);
+	sysfsfp = fopen(temp, "w");
+	if (sysfsfp == NULL) {
+		printf("failed to open the rb length file at %s\n", temp);
+		return -1;
+	}
+	fprintf(sysfsfp, "%d", RingLength);
+	fclose(sysfsfp);
+	/* Create relevant device Nodes */
+	sprintf(temp, "%sring_buf0_acc_minor", BaseDirectoryName);
+	sysfsfp = fopen(temp, "r");
+	if (sysfsfp == NULL) {
+		printf("failed to open minor stuff %s \n", temp);
+		return -1;
+	}
+
+	fscanf(sysfsfp, "%d\n", &minor);
+	sprintf(name_chrdevring, "/dev/indring%d", minor);
+
+	fclose(sysfsfp);
+	sprintf(temp, "%sring_buf0_ev_minor", BaseDirectoryName);
+	sysfsfp = fopen(temp, "r");
+	if (sysfsfp == NULL) {
+		printf("failed to open minor stuff \n");
+		return -1;
+	}
+
+	fscanf(sysfsfp, "%d\n", &minor_ev);
+	fclose(sysfsfp);
+
+	/* set scan of x accel */
+	{
+		sprintf(temp, "%s/scan_elements/scan_en_accel_x",
+			BaseDirectoryName);
+		sysfsfp = fopen(temp, "w");
+		if (sysfsfp == NULL) {
+			printf("failed to open scan_en_accel_x\n");
+			return -1;
+		}
+		fprintf(sysfsfp, "%d", scanx);
+		fclose(sysfsfp);
+	}
+
+
+	/* set scan of y accel */
+	{
+		sprintf(temp, "%s/scan_elements/scan_en_accel_y",
+			BaseDirectoryName);
+		sysfsfp = fopen(temp, "w");
+		if (sysfsfp == NULL) {
+			printf("failed to open scan_en_accel_y\n");
+			return -1;
+		}
+		fprintf(sysfsfp, "%d", scany);
+		fclose(sysfsfp);
+	}
+
+
+	/* set scan of z accel */
+	{
+		sprintf(temp, "%s/scan_elements/scan_en_accel_z",
+			BaseDirectoryName);
+		sysfsfp = fopen(temp, "w");
+		if (sysfsfp == NULL) {
+			printf("failed to open scan_en_accel_z\n");
+			return -1;
+		}
+		fprintf(sysfsfp, "%d", scanz);
+		fclose(sysfsfp);
+	}
+
+
+	/* set scan of ts */
+	{
+		sprintf(temp, "%s/scan_elements/scan_en_timestamp",
+			BaseDirectoryName);
+		sysfsfp = fopen(temp, "w");
+		if (sysfsfp == NULL) {
+			printf("failed to open scan_en_timestamp\n");
+			return -1;
+		}
+		fprintf(sysfsfp, "%d", scants);
+		fclose(sysfsfp);
+	}
+
+	sprintf(name_chrdevevt, "/dev/indringev%d", minor_ev);
+	/* Enable the ring buffer */
+	{
+		sprintf(temp, "%sring_buffer/ring_enable", BaseDirectoryName);
+		ringcont = fopen(temp, "w");
+
+		if (ringcont == NULL) {
+			printf("Failed to open the rb control file \n");
+			return -1;
+		};
+		fprintf(ringcont, "1");
+		fclose(ringcont);
+	}
+	/* Attempt to open non blocking the access dev */
+	fp = open(name_chrdevring, O_RDONLY | O_NONBLOCK);
+	if (fp == -1) { /*If it isn't there make the node */
+		sprintf(command, "mknod %s c 244 %d; mknod %s c 244 %d; ",
+			name_chrdevring, minor, name_chrdevevt, minor_ev);
+		system(command);
+		sleep(5);
+		fp = open(name_chrdevring, O_RDONLY | O_NONBLOCK);
+		if (fp == -1) {
+			printf("Unable to open %s\n", name_chrdevring);
+			return -1;
+		}
+	}
+	/* Attempt to open the event access dev (blocking this time) */
+	fp_ev = fopen(name_chrdevevt, "rb");
+	if (fp_ev == NULL) {
+
+		printf("bug opening %s\n", name_chrdevevt);
+		return -1;
+	}
+
+	/* Wait for events 10 times */
+	for (j = 0; j < 10; j++) {
+		read_size = fread(&dat, 1, sizeof(struct iio_event_data),
+				  fp_ev);
+		switch (dat.id) {
+		case IIO_EVENT_CODE_RING_100_FULL:
+			toread = RingLength;
+			break;
+		case IIO_EVENT_CODE_RING_75_FULL:
+			toread = RingLength*3/4;
+			break;
+		case IIO_EVENT_CODE_RING_50_FULL:
+			toread = RingLength/2;
+			break;
+		default:
+			printf("Unexpecteded event code\n");
+		}
+		read_size = read(fp, (char *)(data), toread*(datum_size));
+		if (read_size == -EAGAIN)
+			printf("nothing available \n");
+		/* Print out the first 10% of the values recieved from the rb*/
+		for (i = 0; i < (read_size  / datum_size)*0.1; i++) {
+			k = 0;
+			printf("%d, ", sample++);
+			if (scanx)
+				printf("%d, ",
+				       *((__s16 *)(data + i*(datum_size))
+					 + k++));
+			if (scany)
+				printf("%d, ",
+				       *((__s16 *)(data + i*(datum_size))
+					 + k++));
+			if (scanz)
+				printf("%d, ",
+				       *((__s16 *)(data + i*(datum_size))
+					 + k++));
+			if (scants)
+				printf(" %lld ",
+				       *((__s64 *)(data + i*(datum_size))
+					 + ((k+3)/4)));
+			printf("\n");
+
+		}
+
+	}
+	close(fp);
+	fclose(fp_ev);
+	/* Stop the ring buffer */
+	{
+
+		sprintf(temp, "%sring_buffer/ring_enable", BaseDirectoryName);
+		ringcont = fopen(temp, "w");
+		if (ringcont == NULL) {
+			printf("Failed to open the rb control file \n");
+			return -1;
+		};
+		fprintf(ringcont, "0");
+
+		fclose(ringcont);
+	}
+
+	free(BaseDirectoryName);
+	free(data);
+
+	return 0;
+}
