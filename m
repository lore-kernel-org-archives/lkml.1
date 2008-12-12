Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYLLUPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYLLUPz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 15:15:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYLLUPs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 15:15:48 -0500
Received: from 201-217-static-ppp.3menatwork.com ([64.235.217.201]:60492 "EHLO
	server.hugovil.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751865AbYLLUPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 15:15:47 -0500
X-Greylist: delayed 751 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Dec 2008 15:15:47 EST
Date: Fri, 12 Dec 2008 15:03:14 -0500
From: Hugo Villeneuve <hugo@hugovil.com>
To: linux-kernel@vger.kernel.org
Subject: FPGA programming driver architecture
Message-Id: <20081212150314.6ea24996.hugo@hugovil.com>
X-Mailer: Sylpheed 2.6.0rc (GTK+ 2.10.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Greylist: Default is to whitelist mail, not delayed by milter-greylist-3.0 (server.hugovil.com [64.235.217.201]); Fri, 12 Dec 2008 15:03:16 -0500 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have written some code to program a FPGA in Linux, for two different types of boards: one uses a serial interface (SPI) and the second a parallel interface. I have been able to sucessfully program both boards. I'm now trying to clean my code and make it more generic, as well as better in line with the Linux driver model. I would also like to include it in the mainline kernel if there is interest.

Here is a description of the current architecture (refer to diagrams below): The fpgaload module controls one output GPIOs (PROG), and two input GPIOs (INIT and DONE). These GPIOs are specified in board setup code. Both fpgaload_ser and fpgaload_par modules export a single function to write a byte. The fpgaload driver is a char device to which we can write (/dev/fpgaload) to program a bitstream (FPGA firmware) inside the FPGA. The fpgaload driver will toggle the GPIOs to initiate programming and the then call the corresponding write_byte function based on the interface type specified in board setup code (serial or parallel, or any future interface desired).


FPGA serial bitstream loading architecture

+----------------------+
| FPGA load driver     |
| (fpgaload)           |
+----------------------+
  |             |
  |    +----------------+
  |    | FPGA serial    |
  |    | load driver    |
  |    | (fpgaload_ser) |
  |    +----------------+
  |             |
  |    +-------------------+
  |    | SPI master        |
  |    | controller driver |
  |    +-------------------+
  |             |
  |             |           Linux
------------------------------------
  |             |           HARDWARE
  |             |spi
  |             |
  |      +--------------+
  |      | SPI          |
  +----->| Programming  |
   GPIOs | interface    |
         +--------------+
                    FPGA


FPGA parallel bitstream loading architecture

+----------------------+
| FPGA load driver     |
| (fpgaload)           |
+----------------------+
  |             |
  |    +----------------+
  |    | FPGA parallel  |
  |    | load driver    |
  |    | (fpgaload_par) |
  |    +----------------+
  |             |
  |             |           Linux
------------------------------------
  |             |           HARDWARE
  |             |parallel
  |             |
  |      +--------------+
  |      | Parallel     |
  +----->| Programming  |
   GPIOs | interface    |
         +--------------+
                    FPGA


The problem with that approach is that when loading the fpgaload module with modprobe, it will automatically try to load the fpgaload_ser and fpgaload_par modules, even if only serial interface was specified in board setup code for example. This is not good when building a kernel for similar but different boards.

Probably a better approach would be for the fpgaload_Ser and fpgaload_par modules to register themselves with the fpgaload module. Then, should the fpgaload module be built using a BUS driver structure? Or anyone having any suggestions on how it should be implemented?

Hugo Villeneuve
