Return-Path: <linux-kernel-owner+w=401wt.eu-S1762639AbXKIEsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762639AbXKIEsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 23:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758728AbXKIEs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 23:48:27 -0500
Received: from gateway-1237.mvista.com ([63.81.120.158]:8645 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXKIEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 23:48:26 -0500
Message-ID: <4733E68C.1040307@schaufler-ca.com>
Date: Thu, 08 Nov 2007 20:48:12 -0800
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: akpm@osdl.org, torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       method@manicmethod.com
Subject: [PATCH 0/2] Version 11 (2.6.24-rc2) Smack: Simplified Mandatory Access
 Control Kernel
Content-Type: multipart/mixed;
 boundary="------------020804020305000607030405"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020804020305000607030405
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


This is version 11 of the Simplified Mandatory Access Control Kernel.

The whole thing as available on the Smack home page at

    http://schaufler-ca.com

The attachments to this message are not kernel code.
They are early versions of the smackload and smackcipso
programs, and are included in the hope that doing so
may reduce (I certainly wouldn't count on it eliminating)
whinging about the revised versions of smack_write_load()
and smack_write_cipso().

The /smack/load and /smack/cipso special files are a minor
component of Smack, and much too much energy has gone into
them, and I would much prefer that people who don't like
Smack crux about things that are important rather than the
details and moral implications of parsers in kernel code.

Writes to /smack/load are now required to have this format:

    SubjectLabel ObjectLabel Mode[decorations]
    | 24 bytes  || 24 bytes ||4 ||undefined  |

A write to /smack/load must be 52 or more bytes in length.
The 4 mode bytes must be of the form [rR-][wW-][xX-][aA-],
in that order. The regular rules enforced by smack_import()
apply to the strings at offset 0 and offset 24.

Writes to /smack/cipso are now required to have this format:

    LabelMapped Level CatCount [cat]...
    | 24 bytes || 4  ||  4    | |4|


A write to /smack/cipso must be at least 32 bytes long,
and also must be 32 + (4 * CatCount) bytes long. If there
are no categories CatCount must be "0   ". The label is
read using smack_import(). All other values are left
justified ("2   ", not "   2") integers in 4 bytes.

Since these formats are so fussy I have provided programs
that take care of that. They are still human readable text,
but no longer require parsing in the kernel. It is my sincere
hope that we can put the bruhaha about parsing to bed.

Two patches here. Paul Moore's netlabel api patch has been updated
due to unrelated changes in that code.



--------------020804020305000607030405
Content-Type: text/plain;
 name="smackload.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smackload.c"

/*
 * smackload - properly format smack access rules for
 * loading into the kernel by writing to /smack/load.
 *
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LSIZE 23
#define ASIZE 4

int
main(int argc, char *argv[])
{
	int loadfd;
	char line[80];
	char rule[LSIZE + LSIZE + ASIZE + 3];
	char subject[LSIZE+1];
	char object[LSIZE+1];
	char accesses[ASIZE+1];
	char real[ASIZE+1];
	char *cp;
	int i;
	int err;

	loadfd = open("/smack/load", O_RDWR);
	if (loadfd < 0) {
		perror("opening /smack/load");
		exit(1);
	}

	while (fgets(line, 80, stdin) != NULL) {
		err = 0;
		if ((cp = strchr(line, '\n')) != NULL)
			*cp = '\0';
		if (sscanf(line,"%23s %23s %4s",subject,object,accesses) != 3) 
			err = 1;
		else {
			strcpy(real, "----");
			for (i = 0;
			     i < ASIZE && accesses[i] != '\0' && err == 0;
			     i++) {
				switch (accesses[i]) {
				case 'r':
				case 'R':
					real[0] = 'r';
					break;
				case 'w':
				case 'W':
					real[1] = 'w';
					break;
				case 'x':
				case 'X':
					real[2] = 'x';
					break;
				case 'a':
				case 'A':
					real[3] = 'a';
					break;
				case '\0':
				case '-':
					break;
				default:
					err = 1;
					break;
				}
			}
		}
		if (err == 0) {
			fprintf(stderr, "Good input line \"%s\"\n", line);
			sprintf(rule, "%-23s %-23s %4s", subject,object,real);
			fprintf(stderr, "Sending in line \"%s\"\n", rule);
			err = write(loadfd, rule, LSIZE + LSIZE + ASIZE + 2);
			if (err < 0)
				perror("writing /smack/load");
		}
		else
			fprintf(stderr, "Bad input line \"%s\"\n", line);
	}
	exit(0);
}

--------------020804020305000607030405
Content-Type: text/plain;
 name="smackcipso.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="smackcipso.c"

/*
 * smackcipso - properly format smack access cipsos for
 * loading into the kernel by writing to /smack/cipso.
 *
 */
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define LSIZE 23
#define NSIZE 4
#define MAXCATNUM 239
#define MAXCATVAL 63
#define MAXLEVEL 255

int
main(int argc, char *argv[])
{
	int cipsofd;
	char line[512];
	char cipso[LSIZE + NSIZE + NSIZE + (NSIZE * MAXCATNUM)];
	char smack[LSIZE+1];
	char cats[MAXCATNUM+1][NSIZE+1];
	char *cp;
	int level;
	int cat;
	int catcount;
	int i;
	int err;

	cipsofd = open("/smack/cipso", O_RDWR);
	if (cipsofd < 0) {
		perror("opening /smack/cipso");
		exit(1);
	}

	while (fgets(line, sizeof(line), stdin) != NULL) {
		catcount = 0;
		err = 0;

		if ((cp = strchr(line, '\n')) == NULL) {
			fprintf(stderr, "Bad input line \"%s\"\n", line);
			continue;
		}
		*cp = '\0';
		cp = strtok(line, " \t");
		if (cp == NULL) {
			fprintf(stderr, "Bad input line \"%s\"\n", line);
			continue;
		}
		sprintf(cipso, "%-23s ", line);
		if (strlen(cipso) != 24) {
			fprintf(stderr, "Bad input line \"%s\"\n", line);
			continue;
		}
		cp = strtok(NULL, " \t");
		if (cp == NULL || !isdigit(*cp)) {
			fprintf(stderr, "Bad input line \"%s\"\n", line);
			continue;
		}
		level = atoi(cp);
		if (level > MAXLEVEL) {
			fprintf(stderr, "Bad input line \"%s\"\n", line);
			continue;
		}
		sprintf(cipso+LSIZE+1, "%-4d", level);

		cp = strtok(NULL, " \t");
		for (i = 0; cp != NULL; cp = strtok(NULL, " \t"), i++) {
			if (!isdigit(*cp)) {
				fprintf(stderr, "Bad cat \"%s\"\n", cp);
				err = 1;
				break;
			}
			cat = atoi(cp);
			if (i >= MAXCATNUM) {
				fprintf(stderr, "Maximum number of categories exceeded"
					"\"%s\"\n");
				err = 1;
				break;
			}
			if (cat > MAXCATVAL) {
				fprintf(stderr, "Bad cat \"%s\"\n", cp);
				err = 1;
				break;
			}
			sprintf(cats[i], "%-4d", cat);
		}
		if (err)
			continue;

		sprintf(cipso+LSIZE+1+NSIZE, "%-4d", i);
		while (i > 0)
			strcat(cipso, cats[--i]);
		err = write(cipsofd, cipso, strlen(cipso));
		if (err < 0)
			perror("writing /smack/cipso");
		fprintf(stderr, "Good line \"%s\"\n", cipso);
	}
	exit(0);
}

--------------020804020305000607030405--
